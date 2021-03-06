﻿////////////////////////////////////////////////////////////////////
//
//　　　Hayappli
//　　　生まれて初めて公開したクラス。
//　　　TwitterStreaming.asは、ここ(http://pastebin.com/gGLV5H3Y)の改造。
//　　　Clockmakerさんにいろいろアドバイスをいただきました。
//
////////////////////////////////////////////////////////////////////
package jp.hayappli.net.twitter.events
{
	import flash.events.Event;
	public class TwitterStreamingEvent extends Event
	{
		public static const RECEIVE:String = "receive";
		public static const LIMIT:String = "limit";
		public static const ERROR:String = "error";
		public function TwitterStreamingEvent(type:String, bubbles:Boolean = false,cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
		}
		override public function clone():Event
		{
			return new TwitterStreamingEvent(type, bubbles, cancelable);
		}
	}
}