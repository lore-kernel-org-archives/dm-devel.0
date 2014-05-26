From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: 3.15-rc4: circular locking dependency triggered by
 dm-multipath
Date: Mon, 26 May 2014 16:54:43 +0200
Message-ID: <538355B3.9060100@acm.org>
References: <5368ABE8.9050909@acm.org>
	<536B1CC1.6080709@suse.de>	<53832919.8080500@acm.org>
	<53832F2B.9060808@suse.de>	<53833183.7080106@acm.org>
	<538333AC.60103@suse.de> <53833730.50509@suse.de>
	<538338D5.4080804@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <538338D5.4080804@suse.de>
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
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On 05/26/14 14:51, Hannes Reinecke wrote:
> Or, better still, try the attached patch.
> There's one more instance where lockdep might complain.

Does anyone know whether it's safe to revert commit 4cdd2ad780 ? Anyway,
I ran a test with v3.15-rc7 + your patch + 4cdd2ad780 reverted and that
test ran fine. I didn't encounter any lockups nor any lockdep
complaints. The test I ran was to run a fio I/O verification test on top
of a dm-multipath device. That multipath device was created on top of
several SCSI device nodes created by the ib_srp driver. About once every
30 seconds a cable removal / reinsertion was simulated via the
ibportstate command.

Bart.
