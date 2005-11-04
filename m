From: Bernd Zeimetz <bernd@bzed.de>
Subject: Re: Clariion CX600 automatic failback support
Date: Fri, 4 Nov 2005 09:19:06 +0100
Message-ID: <200511040919.07200.bernd@bzed.de>
References: <C2EEB4E538D3DC48BF57F391F422779321ADA0@SRMANNING.eng.emc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <C2EEB4E538D3DC48BF57F391F422779321ADA0@SRMANNING.eng.emc.com>
Content-Disposition: inline
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

> Looks good, except the call to extract_hwe_from_path in setup_multipath
> must be before the call to select_pgfailback.
>

We have a ton of these log messages now.
From the last about 2 hours:

580x multipathd: 3600601f4a20c000099dc229956b0d711: switch to path group =
#1
714x multipathd: 3600601f4a20c000096dc229956b0d711: switch to path group =
#1
714x multipathd: 3600601f2a20c0000fb13caa656b0d711: switch to path group =
#1
  45x kernel: device-mapper: dm-emc: emc_pg_init: sending switch-over com=
mand

It happens only for these 3 of 8 luns.

Kernel is 2.6.13.4, devmapper 1.01, latest multipath-tools from git, evms=
=20
2.5.3

zeus-1:/# cat /etc/multipath.conf
defaults {
        failback                                immediate
}


Since we had a lot of trouble with our CX400 (Hardware problems, but they=
're=20
supposed to be fixed) I'm wondering what these messages mean, and if we s=
till=20
have hardware/software bugs somewhere.

Any ideas?
Thanks for your help!


Bernd
