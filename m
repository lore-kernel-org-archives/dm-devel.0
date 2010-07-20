From: Christophe Varoqui <christophe.varoqui@gmail.com>
Subject: Re: [BUG] multipath-tools: uuid has become meaningless
Date: Tue, 20 Jul 2010 07:35:24 +0200
Message-ID: <1279604124.2841.5.camel@Nokia-N900-42-11>
References: <20100719224528.GA23414@us.ibm.com>
Reply-To: Christophe Varoqui <christophe.varoqui@gmail.com>,
        device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============3892030043323246750=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20100719224528.GA23414@us.ibm.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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


--===============3892030043323246750==
Content-Type: multipart/alternative; boundary="=-qlfCzYypx8QbxeUnQqys"


--=-qlfCzYypx8QbxeUnQqys
Content-Type: text/plain; charset=utf-8
Content-ID: <1279604123.2841.2.camel@Nokia-N900-42-11>
Content-Transfer-Encoding: quoted-printable
X-MIME-Autoconverted: from 8bit to quoted-printable by mx01.colomx.prod.int.phx2.redhat.com id o6K5a15N013960


>=20
> My thoughts on fixing this:
> 1. Technically nothing wrong. Live with it and make sure that device
>=C2=A0 =C2=A0 =C2=A0  mapper's uuid are meaningless for user and fix 'mu=
ltipath -l' to
>=C2=A0 =C2=A0 =C2=A0  not print uuid's.

I don't like this one : the uuid is the communication medium with storage=
 teams in big IT departement.

> 2. Don't support user_friendly_names in initrd. Could be just documente=
d
>=C2=A0 =C2=A0 =C2=A0  or an option to multipath is added to ignore that =
feature and that
>=C2=A0 =C2=A0 =C2=A0  option is used in initrd calls!

I let distributors comment on this one, but I guess it will replace a con=
fusion (a naming file in initrd the sysadmin have to keep in sync) by ano=
ther (root kparm not consistent with what you see on a booted system). I =
personnaly agree that user_friendly_names disabled in initrd would be a s=
afer confuser.

> 3. We could rename the devices instead of reload -- really fixing this!
>=20

This one seems safe.

Regards,
cvaroqui
--=-qlfCzYypx8QbxeUnQqys
Content-Type: text/html; charset=utf-8
Content-ID: <1279604123.2841.4.camel@Nokia-N900-42-11>
Content-Transfer-Encoding: 7bit

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html><head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <meta name="generator" content="Osso Notes">
    <title></title></head>
<body>
<p>
<br>&gt; 
<br>&gt; My thoughts on fixing this:
<br>&gt; 1. Technically nothing wrong. Live with it and make sure that device
<br>&gt;&nbsp; &nbsp; &nbsp; &#32;mapper's uuid are meaningless for user and fix 'multipath -l' to
<br>&gt;&nbsp; &nbsp; &nbsp; &#32;not print uuid's.
<br>
<br>I don't like this one : the uuid is the communication medium with storage teams in big IT departement.
<br>
<br>&gt; 2. Don't support user_friendly_names in initrd. Could be just documented
<br>&gt;&nbsp; &nbsp; &nbsp; &#32;or an option to multipath is added to ignore that feature and that
<br>&gt;&nbsp; &nbsp; &nbsp; &#32;option is used in initrd calls!
<br>
<br>I let distributors comment on this one, but I guess it will replace a confusion (a naming file in initrd the sysadmin have to keep in sync) by another (root kparm not consistent with what you see on a booted system). I personnaly agree that user_friendly_names disabled in initrd would be a safer confuser.
<br>
<br>&gt; 3. We could rename the devices instead of reload -- really fixing this!
<br>&gt; 
<br>
<br>This one seems safe.
<br>
<br>Regards,
<br>cvaroqui</p>
</body>
</html>

--=-qlfCzYypx8QbxeUnQqys--


--===============3892030043323246750==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 7bit


--===============3892030043323246750==--
