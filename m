From: Luca Berra <bluca@comedia.it>
Subject: Re: restart multipathd automatically
Date: Tue, 29 Jan 2008 11:04:46 +0100
Message-ID: <20080129100445.GD15191@percy.comedia.it>
References: <200801211454.m0LEs2p15801@tug.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <200801211454.m0LEs2p15801@tug.org>
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

On Mon, Jan 21, 2008 at 03:54:02PM +0100, Stephen Mike wrote:
>Hi,
>
>To restart multipathd automatically after it dies, is it ok to put, in
>/etc/inittab, a line like this? 
>
># run multipathd at level 4 (restart)
>mphd:4:respawn:/etc/rc.d/init.d/multipathd start
>
no, it is not.

-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \
