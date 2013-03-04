From: Hannes Reinecke <hare@suse.de>
Subject: Re: Chicken and egg problem with multipath-tools
Date: Mon, 04 Mar 2013 12:13:19 +0100
Message-ID: <513481CF.8020405@suse.de>
References: <1362394847.623.YahooMailClassic@web126204.mail.ne1.yahoo.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"; Format="flowed"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1362394847.623.YahooMailClassic@web126204.mail.ne1.yahoo.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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

On 03/04/2013 12:00 PM, Andrei B. wrote:
>
>
> --- On Mon, 3/4/13, Hannes Reinecke <hare@suse.de> wrote:
>
>> From: Hannes Reinecke <hare@suse.de>
>
>>> The problem is that multipathd wants to create a PID
>> file under /var (which is at this time readonly).
>>> This fails and multipathd fails to start.
>>> It took me a lot of testing and reboots until I managed
>> to determine this is the actual problem.
>>>
>
>> Hmm. Why? multipathd can happily live without a PID file;
>> SUSE has been doing this for years (for precisely the same
>> reason).
>> Check the SUSE init scripts.
>
> Official (from author's website) multipath-tools contain a
 > multipathd that has hardcoded PIDFILE location and there is
 > no runtime option to change its location or disable it.
 > Both manpage and source show this.
> Maybe SUSE has a modified multipathd with added option to
 > control PIDFILE creation.
>

multipathd/main.c:1996
         /* Startup complete, create logfile */
         pid_rc =3D pidfile_create(DEFAULT_PIDFILE, daemon_pid);
         /* Ignore errors, we can live without */


No option, but multipathd doesn't _need_ to create a pidfile.
And it certainly won't abort if it cannot create one.

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
