From: Hannes Reinecke <hare@suse.de>
Subject: Re: RHEL6.2: path failures during good path I/O
Date: Mon, 18 Jun 2012 13:16:28 +0200
Message-ID: <4FDF0E0C.1090403@suse.de>
References: <4FD87335.3040300@linux.vnet.ibm.com>
	<20120613131613.GA18293@redhat.com>	<4FDA3840.9030307@linux.vnet.ibm.com>
	<20120614211928.GA30587@redhat.com>
	<4FDEFCFB.70202@linux.vnet.ibm.com>
	<4FDF0AAB.7000001@linux.vnet.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4FDF0AAB.7000001@linux.vnet.ibm.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christian May <cmay@linux.vnet.ibm.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On 06/18/2012 01:02 PM, Christian May wrote:
> So, I've started on my RHEL6.1 system filesystem I/O against 5
> multipath devices. Each multipath device contains 4 partition - two
> of them were mounted and used for fs-I/O. The exerciser was running
> for appr. 2 hours without a single path failure message. Then I'v
> started block I/O against the other 5 multipath devices.
> Pretty soon the first path failure was reported:
> =

Could be a request-queue starvation.
As you're using directio any I/O requests from the checker will be
queued onto the request queue.
If the system is fully loaded it might take some time for the
checker I/O to be actually submitted; occasionally this might be
longer than the I/O timeout of the checker.

I would switch to 'tur' checker and retest.

(Well, _actually_ I would switch to _SLES_ and retest, but I guess
that's beside the point :-)

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
