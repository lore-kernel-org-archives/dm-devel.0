From: Lars Marowsky-Bree <lmb@novell.com>
Subject: Re: [dm-devel] generic wrappers for multi-device FS operations
Date: Tue, 8 Mar 2011 21:16:01 +0100
Message-ID: <20110308201601.GR28182@suse.de>
References: <4D766199.4010307@gmail.com>
 <20110308174308.GP10767@agk-dp.fab.redhat.com>
 <AANLkTi=uMMN3jEdh3auijdxM+1ZR529oPri4HqRaasYx@mail.gmail.com>
 <4D7671DF.4060108@gmail.com>
 <1299609274.2476.180.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1299609274.2476.180.camel@mulgrave.site>
Sender: linux-fsdevel-owner@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>, Ric Wheeler <ricwheeler@gmail.com>
Cc: Karel Zak <kzak@redhat.com>, Josef Bacik <josef@redhat.com>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Wendy Cheng <s.wendy.cheng@gmail.com>, Chris Mason <chris.mason@oracle.com>
List-Id: dm-devel.ids

On 2011-03-08T12:34:34, James Bottomley <James.Bottomley@suse.de> wrote=
:

> There's still the problem of moving the underlying device from being =
a
> plain block device to being a dm one ... what happened to the idea of
> presenting all devices as dm ones to solve this?

Giving remapping abilities to every block device certainly would be
extremly useful.


Regards,
    Lars

--=20
Architect Storage/HA, OPS Engineering, Novell, Inc.
SUSE LINUX Products GmbH, GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
"Experience is the name everyone gives to their mistakes." -- Oscar Wil=
de

--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
