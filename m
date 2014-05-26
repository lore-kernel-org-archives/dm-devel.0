From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: 3.15-rc4: circular locking dependency triggered by
 dm-multipath
Date: Mon, 26 May 2014 14:20:19 +0200
Message-ID: <53833183.7080106@acm.org>
References: <5368ABE8.9050909@acm.org> <536B1CC1.6080709@suse.de>
	<53832919.8080500@acm.org> <53832F2B.9060808@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <53832F2B.9060808@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>
Cc: device-mapper development <dm-devel@redhat.com>, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

On 05/26/14 14:10, Hannes Reinecke wrote:
> Mike Snitzer had a patch in his device-mapper tree:
> 
> dm mpath: fix lock order inconsistency in multipath_ioctl (2014-05-14
> 16:12:17 -0400)
> 
> I was sort of hoping that would address this issue.
> Can you check?

Hello Hannes,

Is it possible that that patch already got included in v3.15-rc6 and
hence that that patch was included in my test ?

$ git log v3.15-rc5..v3.15-rc6 | grep 'dm mpath: fix lock order
inconsistency in multipath_ioctl'
      dm mpath: fix lock order inconsistency in multipath_ioctl
    dm mpath: fix lock order inconsistency in multipath_ioctl

Bart.
