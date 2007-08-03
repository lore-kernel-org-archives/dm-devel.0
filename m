From: Luca Berra <bluca@comedia.it>
Subject: Re: Re: LVM on dmraid breakage
Date: Fri, 3 Aug 2007 21:57:50 +0200
Message-ID: <20070803195749.GA27271@percy.comedia.it>
References: <46B0EAEF.6090305@cfl.rr.com>
	<20070802065012.GA28687@percy.comedia.it>
	<46B254E4.60700@cfl.rr.com> <20070803081133.GB939@percy.comedia.it>
	<46B36F7A.2090601@cfl.rr.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <46B36F7A.2090601@cfl.rr.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com, ataraid-list@redhat.com, linux-lvm@redhat.com
List-Id: dm-devel.ids

On Fri, Aug 03, 2007 at 02:10:02PM -0400, Phillip Susi wrote:
>I agree with moving the partition detection code to user space, but 
>trying to undo it after the fact doesn't help because udev is already 
>processing the add events.  Also you do not need to remove the 
>partitions so long as pvscan understands that it shouldn't be using them.
which is the modification i proposed to lvm tools, isn't it?


>Udev is supposed to be the new model for enumerating devices and 
i know that, and i will withdraw from this discussion, since it might
get to an useless flame war.

Is there any technical reason for not having lvm tools filter out devices that
are used by device mapper?

besides dmraid, think of multipath.

Regards,
L.


-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \
