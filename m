From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Subject: Re: Resizing multipath maps: reload ioctl failed: Invalid
	argument
Date: Wed, 24 Oct 2007 17:10:08 -0400
Message-ID: <471FB4B0.3060309@ce.jp.nec.com>
References: <000101c81648$917e2980$cf42e3c1@pitagora.it>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <000101c81648$917e2980$cf42e3c1@pitagora.it>
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

Hi,

Domenico Viggiani wrote:
>  http://www.redhat.com/archives/dm-devel/2007-August/msg00188.html
> 
> Is it confirmed that online resizing with multipath is impossible?
> 
> If yes, in my opinion, this is a serious limitation to a serious enterprise
> use of Linux.

I'm trying to find a kernel fix for this issue.

I'll post patches for 2.6.23 kernel.
(But it should be easily adaptible to other versions.)

I have tested the patches mainly on modified LVM2 (i.e. resizing
mirror LV).
Since I don't have resizable multipath device,
if you are interested in testing, it would be much appreciated.

Alternative is to use dmsetup directly, as Aaron suggested.
But there is a corner case that if all paths are down before
'dmsetup suspend', I/O errors will occur regardless of
queue_if_no_path setting.

Thanks,
-- 
Jun'ichi Nomura, NEC Corporation of America
