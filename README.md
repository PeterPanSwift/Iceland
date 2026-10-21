# 冰島之旅 Iceland

用 SwiftUI 製作的冰島旅遊介紹 App，包含 12 個熱門景點、景點地圖與冰島基本資料。

- **探索**：極光主視覺、精選景點輪播、依地區分類的景點列表
- **景點介紹**：可伸縮的大圖標頭、亮點、最佳季節、位置地圖、收藏功能
- **地圖**：MapKit 3D 地圖，點選景點標籤即飛到該處，可直接進入介紹頁
- **關於冰島**：基本資料、旅遊小提醒與照片來源

## 照片

景點照片並沒有放在 repo 裡，而是在 CI 建置時由 [`scripts/fetch_photos.py`](scripts/fetch_photos.py)
透過 Wikimedia Commons API 搜尋（優先挑選 *Featured / Quality images of Iceland*），
下載後打包進 App，作者與授權資訊寫入 `credits.json` 並顯示在「關於冰島」頁面。

## 雲端建置與錄影

全部在 GitHub Actions 上完成，不需要本機的 Mac：

1. `runs-on: xcode-27`（macOS 27 + Xcode 27 + iOS 27 模擬器）
2. 下載 Commons 照片 → `xcodegen generate` 產生 Xcode 專案
3. `build-for-testing` 後開機 **iPhone 18 Pro Max** 模擬器
4. `xcrun simctl io recordVideo` 錄影，同時執行 UI 測試 [`AppTourUITests`](IcelandUITests/AppTourUITests.swift) 自動操作 App
5. 影片上傳成 Actions artifact，並 commit 回分支的 [`Recordings/`](Recordings) 資料夾

Workflow：[`.github/workflows/record-demo.yml`](.github/workflows/record-demo.yml)
