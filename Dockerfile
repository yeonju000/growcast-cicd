# OpenJDK 17 기반 이미지 사용
FROM openjdk:17-jdk-slim

# JAR 파일 복사
COPY build/libs/*.jar app.jar

# 3030 포트 노출
EXPOSE 3030

# JAR 실행
ENTRYPOINT ["java", "-jar", "/app.jar"]