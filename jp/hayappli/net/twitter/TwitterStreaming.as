/////////////////////////////////////////////////////////
//
//　　　Hayappli
//　　　生まれて初めて公開したクラス。
//　　　ここ(http://pastebin.com/gGLV5H3Y)の改造。
//　　　Clockmakerさんにいろいろアドバイスをいただきました。
//
/////////////////////////////////////////////////////////
package jp.hayappli.net.twitter
{
	import com.adobe.serialization.json.*;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	import flash.net.URLStream;
	
	import jp.hayappli.net.twitter.events.TwitterStreamingEvent;
	
	import mx.utils.Base64Encoder;
	public class TwitterStreaming extends EventDispatcher
	{
		private var request:URLRequest;
		private var amountRead:int = 0;
		private var streamBuffer:String;
		private var streamBufferArr:Array
		private var _tweet:Object;
		private var stream:URLStream;
		private var _streaming:Boolean;
		public function TwitterStreaming(url:String,username:String,password:String)
		{
			streamBuffer="";
			streamBufferArr=[];
			request = new URLRequest("http://" + url);
			var b64encoder:Base64Encoder= new Base64Encoder();
			b64encoder.encode(username + ":" + password);
			request.requestHeaders = new Array(new URLRequestHeader("Authorization","Basic " + b64encoder.toString()));
			request.method = URLRequestMethod.POST;
			request.data = 0;
			stream = new URLStream();
		}
		
		private function received(pe:ProgressEvent):void
		{
			var toRead:Number = pe.bytesLoaded - amountRead;
			var buffer:String = stream.readUTFBytes(toRead);
			amountRead = pe.bytesLoaded;
			if (buffer !== "\r\n")
			{
				streamBuffer +=  buffer;
				streamBufferArr = streamBuffer.split("\r\n");
				if (streamBufferArr.length > 1)
				{
					//じぇいそん
					_tweet = JSON.decode(streamBufferArr[0]);
					streamBufferArr.shift();
					//もとに戻す
					streamBuffer = streamBufferArr.join("\r\n").toString();
					if(_tweet.limit!==undefined){
						dispatchEvent(new TwitterStreamingEvent(TwitterStreamingEvent.LIMIT));
					}else{
						dispatchEvent(new TwitterStreamingEvent(TwitterStreamingEvent.RECEIVE));
					}
				}
			}
		}
		private function error(io:IOErrorEvent):void
		{
			dispatchEvent(new TwitterStreamingEvent(TwitterStreamingEvent.ERROR));
			amountRead = 0;
			streamBuffer = "";
		}
		public function set streaming(value:Boolean):void{
			if(value!==_streaming){
				//常に適応されてたら無視
				
				if(value){
					stream.addEventListener(IOErrorEvent.IO_ERROR, error);
					stream.addEventListener(ProgressEvent.PROGRESS, received);
					stream.load(request);
					//trace("true");
				}else if (!value){
					stream.removeEventListener(IOErrorEvent.IO_ERROR, error);
					stream.removeEventListener(ProgressEvent.PROGRESS, received);
					stream.close();
					amountRead = 0;
					streamBuffer = "";
					//trace("false");
				}
			}
			_streaming=value;
		}
		public function get streaming():Boolean{
			return _streaming;
		}
		public function get tweet():Object{
			return _tweet;
		}
	}
}