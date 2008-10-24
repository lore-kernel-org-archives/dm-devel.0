From: Prakash Rudraraju <prakash@jigsaw.com>
Subject: RE: multipathd segfault and SCSI errors
Date: Fri, 24 Oct 2008 08:39:13 -0700
Message-ID: <0FCB6A1400B4B9469B7661BFE02AFC2E0B289DA578@mailx.jigsaw.com>
References: <0FCB6A1400B4B9469B7661BFE02AFC2E0B289DA4F1@mailx.jigsaw.com>
	<20081024133041.GA28671@mars.virtualiron.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20081024133041.GA28671@mars.virtualiron.com>
Content-Language: en-US
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

Eliminating the local disk /dev/sda by adding it to blacklist solved the =
problem of segmentation fault during boot up.

blacklist {
        devnode "^(ram|raw|loop|fd|md|dm-|sr|scd|st)[0-9]*"
        devnode "^(hd|xvd)[a-z]*"
        devnode "sda"
        wwid "*"
}

I am currently importing the database to check for path failures during l=
oad. It takes about 12 hours to complete, but we had no path failures so =
far.

I will get "multipathd -v9 -d" after the import is complete.

# multipathd -v9 -d
Oct 24 08:38:39 | --------start up--------
Oct 24 08:38:39 | read /etc/multipath.conf
Oct 24 08:38:39 | process is already running

Thanks,
Prakash.


-----Original Message-----
From: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com] On=
 Behalf Of Konrad Rzeszutek
Sent: Friday, October 24, 2008 6:31 AM
To: device-mapper development
Subject: Re: [dm-devel] multipathd segfault and SCSI errors

> multipathd[7165]: segfault at 000000000000000a rip 00002aaaaaf51a3d rsp=
 00007fff03b50090 error 4

Can you run multipathd as so:

multipathd -v9 -d

And provide the -200 lines output from the segfault output? You might nee=
d to
edit the /etc/init.d/multipathd to have this work and pipe the output to =
a log file or so.

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel
