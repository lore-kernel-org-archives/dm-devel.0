From: Luca Berra <bluca@comedia.it>
Subject: Re: multipath with dual Compaq SA462 connected to MSA500
Date: Sat, 14 Oct 2006 10:39:51 +0200
Message-ID: <20061014083951.GF17336@percy.comedia.it>
References: <37429.195.37.166.71.1160475673.squirrel@io3.huck.it>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <37429.195.37.166.71.1160475673.squirrel@io3.huck.it>
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

On Tue, Oct 10, 2006 at 12:21:13PM +0200, Andreas Huck wrote:
>The drives do not register as scis defices and to not appear in
>/proc/scsi/scsi. Therefore, /sbin/scsi_id -g -u -s /block/%n
>does not work of course.

/sbin/scsi_id .... is only one of the possible getuid_callout
you can just change it to something else or even write your own

L.

-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \
