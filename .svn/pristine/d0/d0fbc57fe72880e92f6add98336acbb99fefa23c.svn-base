package com.components.custom.views
{
	import com.components.ZView;
	import com.core.coreGraphics.CGSize;
	import com.core.utils.Broadcast;
	
	import flash.events.ActivityEvent;
	import flash.media.Camera;
	import flash.media.Video;

	/**扩展型摄像头
	 * @author leetn-dmt-zavy
	 */
	public class ExtensionCamera extends ZView
	{
		protected var _camera: Camera;
		protected var _video: Video;
		
		public function ExtensionCamera()
		{
			super();
		}
		
		public function reset(posX: Number, posY: Number, sightWidth: Number, sightHeight: Number, fps: Number = 20, quality: int = 100, size: CGSize = null): void
		{
			if (Camera.names.length < 1)
			{
				Broadcast.show("无可用摄像头");
				return;
			}
			_camera = Camera.getCamera();
			
			if (_camera.hasEventListener(ActivityEvent.ACTIVITY) == false)
				_camera.addEventListener(ActivityEvent.ACTIVITY, onActivity);
			_camera.setMode(sightWidth, sightHeight, fps, true);
			_camera.setQuality(0, quality);
			if (size)
			{
				_video = new Video(size.width, size.height);
			}
			else
			{
				_video = new Video(_camera.width, _camera.height);
			}
			_video.attachCamera(_camera);
			_video.smoothing = true;
			_video.x = posX;
			_video.y = posY;
			this.addChild(_video);
		}
		
		protected function onActivity(e: ActivityEvent): void
		{
			trace("摄像头状态 : " + e.activating);
		}
		
		override public function deinit():void
		{
			if (_camera)
			{
				_camera.removeEventListener(ActivityEvent.ACTIVITY, onActivity);
				_camera = null;
			}
			if (_video)
			{
				_video.attachCamera(null);
				if (_video.parent)
					_video.parent.removeChild(_video);
				_video = null;
			}
		}
		//
	}
}


