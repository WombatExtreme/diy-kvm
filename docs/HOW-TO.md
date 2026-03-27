# 📖 Wombat-KVM Operator's Guide
**"Smart Tech Done Right"**

### 🎮 Remote Controlling a PC
1.  **Access:** Navigate to `http://[D520-IP]:5000` on your Windows 11 machine or Phone.
2.  **Interaction:** Click anywhere on the video stream to focus. Your keyboard now controls the target PC.
3.  **Special Keys:** Use the **Red Buttons** for Ctrl+Alt+Del if the target PC is locked or frozen.

### 📱 Using your Phone (Mobile Mode)
1.  Connect to your **Tailscale** network on your phone.
2.  Open the KVM URL in your mobile browser.
3.  **To Type:** Tap the "Mobile Input" text area at the bottom. Your mobile keyboard will pop up. Whatever you type there is sent instantly to the remote PC.

### 📸 Capturing Evidence
* Click the **Screenshot** button. The KVM will grab a high-quality JPEG of the current screen and download it directly to your device.
* A copy is also saved on the D520 in `~/diy-kvm/screenshots/`.

### 🔄 Updating the System
When WombatExtreme pushes a new update to GitHub:
1.  Click the **Update App** button in the top dashboard.
2.  Wait 15 seconds for the containers to rebuild.
3.  The page will refresh automatically with the new features.