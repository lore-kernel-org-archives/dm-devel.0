From: Luca Berra <bluca@comedia.it>
Subject: Re: /dev/mdX won't shutdown
Date: Mon, 11 Sep 2006 16:20:18 +0200
Message-ID: <20060911142018.GD13522@percy.comedia.it>
References: <Pine.GSO.4.58.0609111015210.4522@banquo.ucc.usyd.edu.au>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <Pine.GSO.4.58.0609111015210.4522@banquo.ucc.usyd.edu.au>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

On Mon, Sep 11, 2006 at 10:26:27AM +1000, Jie Gao wrote:
>Hi All
>I can shutdown /dev/md1 using "mdadm --stop /dev/md1" and restart it
>after all the above steps except the logical volume creation. I cannot
>shut down /dev/md1 once the logical volume is created: I get the
>following message:

did you deactivate the VG prior to stopping md?

L.

-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \
