From: Bernd Zeimetz <bernd@bzed.de>
Subject: Re: multipath + evms problems
Date: Mon, 31 Oct 2005 23:20:06 +0100
Message-ID: <200510312320.06690.bernd@bzed.de>
References: <200510291248.51290.bernd@bzed.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <200510291248.51290.bernd@bzed.de>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids


Anybody seen these evms erros before?

Oct 29 13:22:54 zeus-2 _2_ Engine: build_target_list: Error getting number of devices and groups from the target type.
Oct 29 13:22:54 zeus-2 _2_ Engine: build_target_list: Error building target list. Name = 3600601f4a20c000096dc229956b0d711
Oct 29 13:22:54 zeus-2 _2_ LocalDskMgr: check_multipath: Error getting DM mapping for disk 3600601f4a20c000096dc229956b0d711.
[...] x 8 - for every LUN


Any idea  where the problem behind this is?
Christophe?

Thanks in advance,

Bernd
