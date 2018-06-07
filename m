From: valdis.kletnieks@vt.edu
Subject: Re: next-20180605 - kernel tried to execute NX-protected page - exploit attempt?
Date: Thu, 07 Jun 2018 18:41:35 -0400
Message-ID: <136327.1528411295@turing-police.cc.vt.edu>
References: <21051.1528404057@turing-police.cc.vt.edu>
 <20180607211401.GD4481@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1528411294_2703P";
         micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180607211401.GD4481@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Alasdair Kergon <agk@redhat.com>, linux-kernel@vger.kernel.org, dm-devel@redhat.com, axboe@kernel.dk
List-Id: dm-devel.ids

--==_Exmh_1528411294_2703P
Content-Type: text/plain; charset=us-ascii

On Thu, 07 Jun 2018 17:14:01 -0400, Mike Snitzer said:
> Can you please share what you test is?  We've gotten lots of reports
> with failure following wake_up but I don't have a canned test to trigger

Just a laptop with 16G of RAM, no clear reproducer -  Chrome with a lot of
tabs, a mail reader, a bunch of SSH windows, and the next thing I know, it's
locked up good and solid with wreckage in /sys/fs/pstore :)

I got bit a third time a little while ago.  Will test the patches and see if
they help - looks like I'm averaging two hours or so of active use before it
hits, so it shouldn't take long before I know if the issue is swatted...

--==_Exmh_1528411294_2703P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Comment: Exmh version 2.8.0 04/21/2017

iQEVAwUBWxm0no0DS38y7CIcAQIGHAf/XtIUwKadG6TE1Cp4TbsXt0252qnv6N2K
4SNCOxJdx1wWh3IcMrTc9Ff/iWuABARWhWjOOFsn88tG81WYBVveuF1rmy+vVlX+
MJ6vTiuJKZDLQxvSn5q/2FA70CnG9OR+Hfih9RTXo9Qqzh5+iLxX6ON/wIgX9big
ANChJeSh5+dtey5LDDy2mL43BXpLtD2vAxtjnrrk0R2pD9qOHmc7eLoBamrE8qwr
BTBUjCMtREE1wO+V5ZCUWmS62gVjlh54rgLEe/Zw3Ug8TZcpRghlVlIgvoUE0IqU
ZlNF8V4422yzu1qDF2moR0YFJxxusamPlxspDOm6+J6JuiHM0X0oKg==
=mIUo
-----END PGP SIGNATURE-----

--==_Exmh_1528411294_2703P--
