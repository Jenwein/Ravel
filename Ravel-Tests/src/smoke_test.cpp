#include <gtest/gtest.h>
#include <nlohmann/json.hpp>
#include <spdlog/spdlog.h>
#include <spdlog/sinks/null_sink.h>

TEST(Smoke, GoogleTestRuns) {
    EXPECT_EQ(1 + 1, 2);
}

TEST(Smoke, NlohmannJsonParses) {
    auto j = nlohmann::json::parse(R"({"k":1})");
    EXPECT_EQ(j.at("k").get<int>(), 1);
}

TEST(Smoke, SpdlogNullSinkInitializes) {
    auto sink = std::make_shared<spdlog::sinks::null_sink_mt>();
    spdlog::logger logger("smoke", sink);
    logger.info("ignored");
    SUCCEED();
}

int main(int argc, char** argv) {
    ::testing::InitGoogleTest(&argc, argv);
    return RUN_ALL_TESTS();
}
