import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hagz_kora/core/storage/secure_storage.dart';
import 'package:mocktail/mocktail.dart';

class _MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {}

void main() {
  late _MockFlutterSecureStorage mockStorage;
  late SecureStorage sut;

  setUp(() {
    mockStorage = _MockFlutterSecureStorage();
    sut = SecureStorage(mockStorage);
  });

  // Stub write/delete to succeed by default.
  void stubWriteOk() {
    when(
      () => mockStorage.write(key: any(named: 'key'), value: any(named: 'value')),
    ).thenAnswer((_) async {});
  }

  void stubDeleteOk() {
    when(
      () => mockStorage.delete(key: any(named: 'key')),
    ).thenAnswer((_) async {});
  }

  group('saveTokens', () {
    test('writes both access and refresh tokens', () async {
      stubWriteOk();

      await sut.saveTokens(access: 'acc123', refresh: 'ref456');

      verify(
        () => mockStorage.write(key: 'access_token', value: 'acc123'),
      ).called(1);
      verify(
        () => mockStorage.write(key: 'refresh_token', value: 'ref456'),
      ).called(1);
    });
  });

  group('getAccessToken', () {
    test('returns token when present', () async {
      when(() => mockStorage.read(key: 'access_token'))
          .thenAnswer((_) async => 'acc123');

      final result = await sut.getAccessToken();
      expect(result, 'acc123');
    });

    test('returns null when absent', () async {
      when(() => mockStorage.read(key: 'access_token'))
          .thenAnswer((_) async => null);

      final result = await sut.getAccessToken();
      expect(result, isNull);
    });
  });

  group('getRefreshToken', () {
    test('returns token when present', () async {
      when(() => mockStorage.read(key: 'refresh_token'))
          .thenAnswer((_) async => 'ref456');

      final result = await sut.getRefreshToken();
      expect(result, 'ref456');
    });
  });

  group('clearTokens', () {
    test('deletes both tokens', () async {
      stubDeleteOk();

      await sut.clearTokens();

      verify(() => mockStorage.delete(key: 'access_token')).called(1);
      verify(() => mockStorage.delete(key: 'refresh_token')).called(1);
    });
  });

  group('hasTokens', () {
    test('returns true when access token is present and non-empty', () async {
      when(() => mockStorage.read(key: 'access_token'))
          .thenAnswer((_) async => 'acc123');

      expect(await sut.hasTokens(), isTrue);
    });

    test('returns false when access token is null', () async {
      when(() => mockStorage.read(key: 'access_token'))
          .thenAnswer((_) async => null);

      expect(await sut.hasTokens(), isFalse);
    });

    test('returns false when access token is empty string', () async {
      when(() => mockStorage.read(key: 'access_token'))
          .thenAnswer((_) async => '');

      expect(await sut.hasTokens(), isFalse);
    });
  });
}
