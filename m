Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42D04C433FE
	for <dm-devel@archiver.kernel.org>; Wed,  2 Feb 2022 06:19:03 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-567-XYxo2lq7NF2ZwNxmM7YZTQ-1; Wed, 02 Feb 2022 01:18:53 -0500
X-MC-Unique: XYxo2lq7NF2ZwNxmM7YZTQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 86EA2802924;
	Wed,  2 Feb 2022 06:18:49 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2E2654EC66;
	Wed,  2 Feb 2022 06:18:49 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 1167F4CA93;
	Wed,  2 Feb 2022 06:18:46 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
	[10.11.54.10])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 20V98qfo011348 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 31 Jan 2022 04:08:53 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id CECDA401E31; Mon, 31 Jan 2022 09:08:52 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id CA56E401E25
	for <dm-devel@redhat.com>; Mon, 31 Jan 2022 09:08:52 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A02583C021A8
	for <dm-devel@redhat.com>; Mon, 31 Jan 2022 09:08:52 +0000 (UTC)
Received: from aei.acropole-expert.com (aei.acropole-expert.com
	[212.146.231.171]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-464-5wC2XBz0MDOu4oqU1JCwBw-2; Mon, 31 Jan 2022 04:08:49 -0500
X-MC-Unique: 5wC2XBz0MDOu4oqU1JCwBw-2
To: <dm-devel@redhat.com>
Date: Mon, 31 Jan 2022 09:08:49 +0000
Feedback-ID: 212.146.231.171:3467908_339:3467908:Sendinblue
From: Acropole Expert Informatique <commercial@acropole-expert.com>
List-Unsubscribe-Post: List-Unsubscribe=One-Click
MIME-Version: 1.0
Message-Id: <202231010908.67qhogh9pd5czj@aei.acropole-expert.com>
Precedence: bulk
X-Csa-Complaints: csa-complaints@eco.de
X-Mailin-Campaign: 339
X-Mailin-Client: 3467908
X-sib-id: L3toeRnSefN0KfrwYJQBaA_wS_paco6uzAgs5B_XkEVMGSP1T2PlsWBWNCvQjgwkBqlWEwinOrFzpEslTBcURVXCw51R8TjDocW7j9b3_MMlyNhKv3aDWtn7uK_onTI8NmxO-44qGXyhqMBrCfTJQ7FYvLvKCpRyL-LS4UVct53JtevDDF3JAZlDADwTcbbqM8fpYqHPj5MBitWQV5RPf92ffArt-Mlg
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Mimecast-Bulk-Signature: yes
X-Mimecast-Spam-Signature: yes
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Wed, 02 Feb 2022 01:18:44 -0500
Subject: [dm-devel] TABLEO : le tout nouvel outil de PILOTAGE de votre
	entreprise : ULTRA simple et convivial
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Reply-To: f.moreno@acropole-expert.com
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/mixed; boundary="===============5642147019853032299=="

--===============5642147019853032299==
Content-Type: multipart/alternative; boundary="-------?=_68678-9548238861268"

---------?=_68678-9548238861268
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8

#

#

#

#

#

Vous souhaitez mesurer et piloter la performance de votre entreprise de man=
i=C3=A8re tr=C3=A8s simple en ayant tout sous les yeux ?

Vous recherchez un Tableau de bord dynamique et personnalisable avec des in=
dicateurs de performance qui pourraient vous permettre de suivre toutes les=
 statistiques de votre entreprise ?

#

[Centre Ouest Informatique]

#

TABLEO est un outil pragmatique et agile
au service des performances de votre entreprise

Il vous permet de piloter votre activit=C3=A9 en construisant et suivant le=
s principaux indicateurs de votre entreprise, en requ=C3=AAtant sur la base=
 du fichier de vos =C3=A9critures comptables.

#

Pourquoi choisir TABLEO ?

Cette solution a =C3=A9t=C3=A9 con=C3=A7ue en =C3=A9troite collaboration av=
ec des experts-comptables

Depuis 40 ans, nous faisons partie d=E2=80=99un groupe familial entrepreneu=
rial ind=C3=A9pendant et avons toujours eu =C3=A0 c=C5=93ur de concevoir, d=
=C3=A9velopper, et d=C3=A9ployer des outils et solutions simples, durables =
et robustes, mais r=C3=A9pondant parfaitement et sans fioritures, aux besoi=
ns des utilisateurs du quotidien.

Notre ADN est de nous baser sur le v=C3=A9cu =C3=A0 la fois d'utilisateurs =
professionnels mais surtout d'utilisateurs comme vous-m=C3=AAme, sur la bas=
e d=E2=80=99un r=C3=A9el partenariat.
Nos solutions s'am=C3=A9liorent sans cesse par retours d'exp=C3=A9rience.

#

Les avantages de TABLEO :

-  Gagnez en productivit=C3=A9=E2=80=8B

-  Plateforme accessible depuis n'importe quel navigateur
-  Bo=C3=AEte =C3=A0 outil compl=C3=A8te :indicateurs, graphiques, =E2=80=
=A6
-  R=C3=A9cup=C3=A9ration automatique des donn=C3=A9es comptables

-  Gagnez en efficacit=C3=A9

-  G=C3=A9n=C3=A9ration automatique des tableaux de bord
-  Commentaires & analyses historis=C3=A9es
-  Saisie budg=C3=A9taire simplifi=C3=A9e

-  Pilotez votre activit=C3=A9

-  Restitutions graphiques claires et modernes
-  Mix des donn=C3=A9es comptables, extracomptables et budg=C3=A9taires
-  Partage des tableaux de bord enmail, PDF, ...

Avec TABLEO, prenez les commandes de votre entreprise, pilotez pour mieux p=
erformer, =C3=A9changer pour aller plus loin.

#

Nous serons ravis de pouvoir vous pr=C3=A9senter notre gamme.

Pour cela, nous avons programm=C3=A9 3 dates de Webinaires de 30 minutes po=
ur vous pr=C3=A9senter =C3=A0 distance les diff=C3=A9rentes fonctionnalit=
=C3=A9s.

Les dates qui vous sont propos=C3=A9es sont les suivantes :

Jeudi 17 F=C3=A9vrier 2022 de 11h00 =C3=A0 11h30
Jeudi 24 Mars 2022 de 11h00 =C3=A0 11h30
Jeudi 14 Avril 2022 de 11h00 =C3=A0 11h30

#

[S'inscrire au Webinaire](http://r.aei.acropole-expert.com/mk/cl/f/45ciLqPl=
N0QTHtJjriyhTKMdqBv-IHfmIVtNcafsVOGOGeNPBr2ei5FIFXafzCtuYGyOA49ta9hlzUU5C04=
kFSZBmrESdWc0webOAR91gGUdjt-Zd-oJkmKju7BCpozStrUdGlh8CHK98xs7NGrPGIgEeLhJuz=
sJ12KNk1MyNiSGSAVKn0YIdDUqS9Ye_6wZF9H5WeEp1cPcK-srbQfIROw7bQQ)

#

Bien entendu, nous serons =C3=A9galement heureux de vous pr=C3=A9senter not=
re gamme compl=C3=A8te de solutions et de logiciels :

#

#

Parce que vos pr=C3=A9occupations sont aussi les n=C3=B4tres, nous ferons t=
oujours le maximum pour vous satisfaire, en concevant des solutions perform=
antes !

Alors, n'attendez plus en nous contactant au :
05 56 69 07 72
ou via notre site : www.acropole-expert.com
ou bien en remplissant le formulaire ci-dessous.

#

[Demander plus d'informations](http://r.aei.acropole-expert.com/mk/cl/f/J5l=
fVZCMkjlY5kgrG1_rvnpELP0T04HmaAx4GVotg2tevgbozCkKODZjp_5QLKo98V6P6CgWtOb3WZ=
THoJcvzEY7_ZeR4eba9cvWJW5iQFQXEl9Jm7EVDyDDpae7OZ9_puvXK13Yaa9bMBC0lETdzQ5x_=
CglYaJMR7rJyL6G6Ae0DWxdzrOAWZiLxg6Sbri6WMB_EaCBgm2flWh9W2rDPZ_mmkzRaaLR_npe=
sxS42uPhVY1B2Wbs6YZEtcgKN1uFMHmpfuVI8Iuyf_jHCOKrwyZ7Kg33APhal2WWHHH17GPGE5u=
kXJaTbNRRSrKIHyzHVKQzLrUc9aYg12Ff1WP1NcJLcCULdzq0nNN_W4UChg)

#

ACROPOLE EXPERT INFORMATIQUE
contact@acropole-expert.com
www.acropole-expert.com
119 Avenue Gambetta - 17100 Saintes
05 46 74 12 25
2 rue Jean Pommi=C3=A8s - 33520 Bruges
05 56 69 07 72

[Facebook](http://r.aei.acropole-expert.com/mk/cl/f/fb0pv2-6zocJkFEUuiJJHII=
d33aM3ynQ0iTSZmXp6N3tZLqySF-al49I4xfIpQyTXGHojGrwIlp2AsMMTz0jgeGmsxCpxEG7FW=
mwpgWcEyJau-sA8n9eysRLrzp6ADxFWiiOnCUHkMOsawAdBg--jL7qUN97HZjzroKeJ-RHswUEf=
IR28ebTE6VI3GfMwrHYZO4TUSoua5dICe0lsFpkdcm9y68nAmEDNi1DUJmw1ao)

[Twitter](http://r.aei.acropole-expert.com/mk/cl/f/m6oyZH5ZbdDMbjYMgvFy3jyJ=
UY0tYIAGoNg1zUHNElaIF7LjJvXbPAmp4gEViFvyIqzpr_G6Q8NP7Asfwi26ajBLBbf8cjzKhzo=
D8ODZaLsfA9uFNHCRj91GPSCAOcexxtQxPNagjm0C5K_fPl4TX13ZxqzIRue49-6nVTVbo1hOlm=
I0Lvsss_3RPVQrPsXcqOJYK_FdijjUJ-ehvrHF)

[LinkedIn](http://r.aei.acropole-expert.com/mk/cl/f/6BeCbNcNTWDGgqseYP-eYJ0=
x1QINcwIGdJAcYqj-zAJ507dHryMU0LJabIWvAJMJkmXX8YoijOFNh6SGAcq89t0pwARPK3mVXy=
6orsP0u7HiwaxkoTN85ickRiHC7u5MCiUTQe5Tw-nXEJKplpsQ-d2hVLwIM2QWYReWoDA469Q6K=
EmPmQN3u9dNegu6kR3OKiCsGneoBa1E_kdHARfgQAOvbG_17xZaLhTDA94nv72Y6MBCMtsf6g7a=
TreOfuY)

[Youtube](http://r.aei.acropole-expert.com/mk/cl/f/J8NWUw-SRS2c8cgSkOpNToGr=
xqinvTgxW-2LefXYoZip_vL4Q93iwMTRdEt3K7EVgQc36BEd9Gycsx2ZKbD5VzWTUQvFxlmA3W3=
gJ-abN_BZHQvD7_TobYFHvx4CCcE2moE3EJ5W3ZkSfnQqaYO7hLPYFpNR5f0qc1j3T0cySLw9YE=
-8nDJPmg94pdTARxik3XmsJICBbY2PYm1xKOts4pDKjlibHxUuau-7ClTx2KC9Ac2Zx5kJ)

#

#

#

Cet e-mail a =C3=A9t=C3=A9 envoy=C3=A9 =C3=A0 dm-devel@redhat.com
Vous avez re=C3=A7u cet email car vous vous =C3=AAtes inscrit sur Centre Ou=
est Informatique.

[Se d=C3=A9sinscrire](http://r.aei.acropole-expert.com/mk/un/r_49Jtk8cFbCmO=
OwoYQcsFQZ6BAs5ixSd6EBsV1kLHuiQZ_jE5kM-ZMKWV3_DwJAVC4eKw3Qpa90QV0C7zQBlwotT=
jV0MpXAdrxHviVZE759v4hLw4h32OX4KIt-oJJZ_ZfMPqQJCK6iMYnGCqbwlY8fr9gfgXmkbiJH=
pvk1P1WD)

#

=C2=A9 2021 Centre Ouest Informatique


---------?=_68678-9548238861268
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset=UTF-8

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.=
w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"><html xmlns=3D"http://www.w3.=
org/1999/xhtml" xmlns:v=3D"urn:schemas-microsoft-com:vml" xmlns:o=3D"urn:sc=
hemas-microsoft-com:office:office"><head><meta http-equiv=3D"X-UA-Compatibl=
e" content=3D"IE=3Dedge"/><meta name=3D"viewport" content=3D"width=3Ddevice=
-width, initial-scale=3D1"/><meta http-equiv=3D"Content-Type" content=3D"te=
xt/html; charset=3Dutf-8"/><meta name=3D"x-apple-disable-message-reformatti=
ng"/><meta name=3D"apple-mobile-web-app-capable" content=3D"yes"/><meta nam=
e=3D"apple-mobile-web-app-status-bar-style" content=3D"black"/><meta name=
=3D"format-detection" content=3D"telephone=3Dno"/><title></title><style typ=
e=3D"text/css">.ReadMsgBody{width:100%;background-color:#ebebeb}.ExternalCl=
ass{width:100%;background-color:#ebebeb}.ExternalClass, .ExternalClass p, .=
ExternalClass span, .ExternalClass font, .ExternalClass td, .ExternalClass =
div{line-height:100%}a[x-apple-data-detectors]{color:inherit !important;tex=
t-decoration:none !important;font-size:inherit !important;font-family:inher=
it !important;font-weight:inherit !important;line-height:inherit !important=
;}body{-webkit-text-size-adjust:none;-ms-text-size-adjust:none}body{margin:=
0;padding:0}.yshortcuts a{border-bottom:none !important}.rnb-del-min-width{=
min-width:0 !important;}.templateContainer{max-width:590px !important;width=
:auto !important;}img[class=3D"rnb-col-3-img"]{max-width:170px;}img[class=
=3D"rnb-col-2-img"]{max-width:264px;}img[class=3D"rnb-col-2-img-side-xs"]{m=
ax-width:180px;}img[class=3D"rnb-col-2-img-side-xl"]{max-width:350px;}img[c=
lass=3D"rnb-col-1-img"]{max-width:550px;}img[class=3D"rnb-header-img"]{max-=
width:590px;}.rnb-force-col p, ul, ol{margin:0px!important}.rnb-del-min-wid=
th p, ul, ol{margin:0px!important}.rnb-tmpl-width{width:100%!important}.rnb=
-social-width{padding-right:15px!important}.rnb-social-align{float:right!im=
portant}li{mso-margin-top-alt:0;mso-margin-bottom-alt:0}table{mso-table-lsp=
ace:0pt;mso-table-rspace:0pt}table, tr, td{border-collapse:collapse}p,a,li,=
blockquote{mso-line-height-rule:exactly}.msib-right-img{mso-padding-alt:0 !=
important}@media only screen and (min-width:590px){.templateContainer{width=
:590px !important}}@media screen and (max-width:360px){.rnb-yahoo-width{wid=
th:360px !important}}@media screen and (max-width:380px){.element-img-text{=
font-size:24px !important}.element-img-text2{width:230px !important}.conten=
t-img-text-tmpl-6{font-size:24px !important}.content-img-text2-tmpl-6{width=
:220px !important}}@media screen and (max-width:480px){td[class=3D"rnb-cont=
ainer-padding"]{padding-left:10px !important;padding-right:10px !important;=
}td.rnb-force-nav{display:inherit;}.rnb-social-text-left{width:100%;text-al=
ign:center;margin-bottom:15px;}.rnb-social-text-right{width:100%;text-align=
:center;}}@media only screen and (max-width:600px){.rnb-text-center{text-al=
ign:center !important}th.rnb-force-col{display:block;padding-right:0 !impor=
tant;padding-left:0 !important;width:100%;}table.rnb-container{width:100% !=
important;}table.rnb-btn-col-content{width:100% !important;}table.rnb-col-3=
{float:none !important;width:100% !important;margin-bottom:10px;padding-bot=
tom:10px;}table.rnb-last-col-3{float:none !important;width:100% !important;=
}table.rnb-col-2{float:none !important;width:100% !important;margin-bottom:=
10px;padding-bottom:10px;}table.rnb-col-2-noborder-onright{float:none !impo=
rtant;width:100% !important;margin-bottom:10px;padding-bottom:10px;}table.r=
nb-col-2-noborder-onleft{float:none !important;width:100% !important;margin=
-top:10px;padding-top:10px;}table.rnb-last-col-2{float:none !important;widt=
h:100% !important;}table.rnb-col-1{float:none !important;width:100% !import=
ant;}img.rnb-col-3-img{width:100% !important;}img.rnb-col-2-img{width:100% =
!important;}img.rnb-col-2-img-side-xs{width:100% !important;}img.rnb-col-2-=
img-side-xl{width:100% !important;}img.rnb-col-1-img{width:100% !important;=
}img.rnb-header-img{width:100% !important;margin:0 auto;}img.rnb-logo-img{w=
idth:100% !important;}td.rnb-mbl-float-none{float:inherit !important;}.img-=
block-center{text-align:center !important}.logo-img-center{float:inherit !i=
mportant;}.rnb-social-align{margin:0 auto !important;float:inherit !importa=
nt}.rnb-social-center{display:inline-block}.social-text-spacing{margin-bott=
om:0px !important;padding-bottom:0px !important}.social-text-spacing2{paddi=
ng-top:15px !important}ul{mso-special-format:bullet}}</style><!--[if gte ms=
o 11]><style type=3D"text/css">table{border-spacing: 0; }table td {border-c=
ollapse: separate;}</style><![endif]--><!--[if !mso]><!--><style type=3D"te=
xt/css">table{border-spacing:0}table td{border-collapse:collapse}</style> <=
!--<![endif]--><!--[if gte mso 15]><xml><o:OfficeDocumentSettings><o:AllowP=
NG/><o:PixelsPerInch>96</o:PixelsPerInch></o:OfficeDocumentSettings></xml><=
![endif]--><!--[if gte mso 9]><xml><o:OfficeDocumentSettings><o:AllowPNG/><=
o:PixelsPerInch>96</o:PixelsPerInch></o:OfficeDocumentSettings></xml><![end=
if]--></head><body> <table cellpadding=3D"0" border=3D"0" cellspacing=3D"0"=
 style=3D" mso-hide:all;display:none"><tr><td>Avec TABLEO, prenez les comma=
ndes de votre entreprise, pilotez pour mieux performer, =C3=A9changer pour =
aller plus loin !</td></tr></table> <table border=3D"0" align=3D"center" wi=
dth=3D"100%" cellpadding=3D"0" cellspacing=3D"0" class=3D"main-template" bg=
color=3D"#f9fafc" style=3D"background-color:#f9fafc"> <tbody><tr> <td align=
=3D"center" valign=3D"top"> <!--[if gte mso 9]> <table align=3D"center" bor=
der=3D"0" cellspacing=3D"0" cellpadding=3D"0" width=3D"590" style=3D"width:=
590px;"> <tr> <td align=3D"center" valign=3D"top" width=3D"590" style=3D"wi=
dth:590px;"> <![endif]--> <table border=3D"0" cellpadding=3D"0" cellspacing=
=3D"0" width=3D"590" class=3D"templateContainer" style=3D"max-width:590px!i=
mportant;width:590px"> <tbody><tr> <td align=3D"center" valign=3D"top"> <ta=
ble class=3D"rnb-del-min-width" width=3D"100%" cellpadding=3D"0" border=3D"=
0" cellspacing=3D"0" style=3D"min-width:590px" name=3D"Layout_0" id=3D"Layo=
ut_0"> <tbody><tr> <td class=3D"rnb-del-min-width" valign=3D"top" align=3D"=
center" style=3D"min-width:590px"> <a href=3D"#" name=3D"Layout_0"></a> <ta=
ble width=3D"100%" cellpadding=3D"0" border=3D"0" height=3D"38" cellspacing=
=3D"0"> <tbody><tr> <td valign=3D"top" height=3D"38"> <img width=3D"20" hei=
ght=3D"38" style=3D"display:block;max-height:38px;max-width:20px" alt=3D"" =
src=3D"https://img.aei.acropole-expert.com/im/3467908/15fd9f264001efa066807=
2cabf04073d203e1c628b776e87506daf3661b832d6.gif?e=3DA26T8QTnI8ak7pXVASexuGn=
VI1BcGsz43LEExHfuVzQrb9WldUyzb78ZSl4-ybsF6O7t0YxHS5yZxErx9N_lFhbUiSFCJdwfwi=
tpSsck2zTQIm7lFiquCQkmwKr4Ld6fCnBG0jFioVpOcEQPj6FJzG4kv4-j7NgW5rLVt5ycHRr-d=
LXewPtMhvXnRMpx" sib_img_id=3D"0"/> </td> </tr> </tbody></table> </td> </tr=
> </tbody></table> </td> </tr><tr> <td align=3D"center" valign=3D"top"> <di=
v style=3D"background-color:#ffffff"> <!--[if mso]> <table align=3D"center"=
 border=3D"0" cellspacing=3D"0" cellpadding=3D"0" width=3D"100%" style=3D"w=
idth:100%;"> <tr> <![endif]--> <!--[if mso]> <td valign=3D"top" width=3D"59=
0" style=3D"width:590px;"> <![endif]--> <table class=3D"rnb-del-min-width" =
width=3D"100%" cellpadding=3D"0" border=3D"0" cellspacing=3D"0" style=3D"mi=
n-width:100%;-webkit-backface-visibility:hidden;line-height:10px" name=3D"L=
ayout_8" id=3D"Layout_8"> <tbody><tr> <td class=3D"rnb-del-min-width" valig=
n=3D"top" align=3D"center" style=3D"min-width:590px"> <a href=3D"#" name=3D=
"Layout_8"></a> <table width=3D"100%" class=3D"rnb-container" cellpadding=
=3D"0" border=3D"0" bgcolor=3D"#ffffff" align=3D"center" cellspacing=3D"0" =
style=3D"background-color:#ffffff"> <tbody><tr> <td valign=3D"top" align=3D=
"center"> <table cellspacing=3D"0" cellpadding=3D"0" border=3D"0"> <tbody><=
tr> <td> <div style=3D"border-radius:5px;width:590;;max-width:600px !import=
ant;border-top:0px None #000;border-right:0px None #000;border-bottom:0px N=
one #000;border-left:0px None #000;border-collapse:separate;border-radius:0=
px"> <div><img ng-if=3D"col.img.source !=3D 'url'" border=3D"0" hspace=3D"0=
" vspace=3D"0" width=3D"590" class=3D"rnb-header-img" alt=3D"" style=3D"dis=
play:block;float:left;border-radius:5px" src=3D"https://img.aei.acropole-ex=
pert.com/im/3467908/5ba11fa70a751affcc3e51c69333065c1a81f3443777eea505352f0=
0e0b8cdc9.jpg?e=3Db0Rrzjm_ePO7W2xcx73nxeYy_84CcYHsx0bkvlLFygBKboLKILvys5CCz=
KD_4T63e5asdUNefS7NmtebosrzmGHohUdYYghiilqvFKyp70PtAzseE65nNbKkJ2iWj0is8YgO=
FW1sOc1AkuH_he-47ANnHj7J7gvcsTlUsJEMloE-7eHIIk7JFHKP-SIkg5ig4bH3Ib65Lt2RfL6=
-Ynh1yHdOi7u7u_1-QTJ0nbs" sib_img_id=3D"1"/></div><div style=3D"clear:both"=
></div> </div></td> </tr> </tbody></table> </td> </tr> </tbody></table> </t=
d> </tr></tbody></table> <!--[if mso]> </td> <![endif]--> <!--[if mso]> </t=
r> </table> <![endif]--> </div></td> </tr><tr> <td align=3D"center" valign=
=3D"top"> <div style=3D"background-color:#ffffff"> <!--[if mso]> <table ali=
gn=3D"center" border=3D"0" cellspacing=3D"0" cellpadding=3D"0" width=3D"100=
%" style=3D"width:100%;"> <tr> <![endif]--> <!--[if mso]> <td valign=3D"top=
" width=3D"590" style=3D"width:590px;"> <![endif]--> <table class=3D"rnb-de=
l-min-width" width=3D"100%" cellpadding=3D"0" border=3D"0" cellspacing=3D"0=
" style=3D"min-width:100%;-webkit-backface-visibility:hidden;line-height:10=
px" name=3D"Layout_46" id=3D"Layout_46"> <tbody><tr> <td class=3D"rnb-del-m=
in-width" valign=3D"top" align=3D"center" style=3D"min-width:590px"> <a hre=
f=3D"#" name=3D"Layout_46"></a> <table width=3D"100%" class=3D"rnb-containe=
r" cellpadding=3D"0" border=3D"0" bgcolor=3D"#ffffff" align=3D"center" cell=
spacing=3D"0" style=3D"background-color:#ffffff"> <tbody><tr> <td valign=3D=
"top" align=3D"center"> <table cellspacing=3D"0" cellpadding=3D"0" border=
=3D"0"> <tbody><tr> <td> <div style=3D"border-radius:5px;width:590;;max-wid=
th:2749px !important;border-top:0px None #000;border-right:0px None #000;bo=
rder-bottom:0px None #000;border-left:0px None #000;border-collapse:separat=
e;border-radius:0px"> <div><img ng-if=3D"col.img.source !=3D 'url'" border=
=3D"0" hspace=3D"0" vspace=3D"0" width=3D"590" class=3D"rnb-header-img" alt=
=3D"" style=3D"display:block;float:left;border-radius:5px" src=3D"https://i=
mg.aei.acropole-expert.com/im/3467908/7e15a0505741caf1701e42d683664406b440b=
29ce9dc3118f8c4174129163a54.jpg?e=3DSHwFEILwt_wvgRBkXysYGkPFWMQp7dAKcGCXLnU=
iNgs5njlL-IGJaPBJC17ojVFVD68FqRG7NrFe_jxD0WWNt7T_XdRWRk-n3QJ8B4Dvwi7QINOGct=
KGsFdGzr7ixmRU3iGVvsNVQPTso4YEDclh34yinTB6GBi5Zf4dKwouGLAHzrwZtDoXVr_2O0kl-=
t15-2BwF7cxcWwwiTz-R4BlM27Yty50Ovx4PXubVRo" sib_img_id=3D"3"/></div><div st=
yle=3D"clear:both"></div> </div></td> </tr> </tbody></table> </td> </tr> </=
tbody></table> </td> </tr></tbody></table> <!--[if mso]> </td> <![endif]-->=
 <!--[if mso]> </tr> </table> <![endif]--> </div></td> </tr><tr> <td align=
=3D"center" valign=3D"top"> <table class=3D"rnb-del-min-width" width=3D"100=
%" cellpadding=3D"0" border=3D"0" cellspacing=3D"0" style=3D"min-width:590p=
x" name=3D"Layout_6003" id=3D"Layout_6003"> <tbody><tr> <td class=3D"rnb-de=
l-min-width" valign=3D"top" align=3D"center" style=3D"min-width:590px"> <a =
href=3D"#" name=3D"Layout_6003"></a> <table width=3D"100%" cellpadding=3D"0=
" border=3D"0" height=3D"38" cellspacing=3D"0"> <tbody><tr> <td valign=3D"t=
op" height=3D"38"> <img width=3D"20" height=3D"38" style=3D"display:block;m=
ax-height:38px;max-width:20px" alt=3D"" src=3D"https://img.aei.acropole-exp=
ert.com/im/3467908/407248b07fd3d8f7e8dc20606539d2491090c41e91c9c6c9f7e1162b=
d7833734.gif?e=3Dmq3XE6hTiQcDLCz_sz76kzWvZHs-Up_RvBaYCEky07BzFm9IKe2JR4dvwA=
zY-qoKqFCwV2WvOrcKWdwFAmBepou5zm3tjY4RRlsohKY6U3F30SlGcVpeTpiS6JrXXDCINzlH8=
qCCvQwH9fpJ9_IU8WtHz25jMHnWX79-rCYyQR14Pc6virE1FHZG14xMDBRZg04DtzLDI9VhD17m=
6A" sib_img_id=3D"11"/> </td> </tr> </tbody></table> </td> </tr> </tbody></=
table> </td> </tr><tr> <td align=3D"center" valign=3D"top"> <div style=3D"b=
ackground-color:#ffffff;border-radius:0px"> <!--[if mso]> <table align=3D"c=
enter" border=3D"0" cellspacing=3D"0" cellpadding=3D"0" width=3D"100%" styl=
e=3D"width:100%;"> <tr> <![endif]--> <!--[if mso]> <td valign=3D"top" width=
=3D"590" style=3D"width:590px;"> <![endif]--> <table width=3D"100%" cellpad=
ding=3D"0" border=3D"0" cellspacing=3D"0" name=3D"Layout_2" id=3D"Layout_2"=
><tbody><tr> <td align=3D"center" valign=3D"top"><a href=3D"#" name=3D"Layo=
ut_2"></a> <table border=3D"0" width=3D"100%" cellpadding=3D"0" cellspacing=
=3D"0" class=3D"rnb-container" bgcolor=3D"#ffffff" style=3D"height:0px;back=
ground-color:#ffffff;border-radius:0px;border-collapse:separate;padding:10p=
x 0px 15px"><tbody><tr> <td class=3D"rnb-container-padding" style=3D"font-s=
ize:px;font-family:;color:"> <table border=3D"0" cellpadding=3D"0" cellspac=
ing=3D"0" class=3D"rnb-columns-container" align=3D"center" style=3D"margin:=
auto"> <tbody><tr> <th class=3D"rnb-force-col" align=3D"center" style=3D"te=
xt-align:center;font-weight:normal"> <table border=3D"0" cellspacing=3D"0" =
cellpadding=3D"0" align=3D"center" class=3D"rnb-col-1"> <tbody><tr> <td hei=
ght=3D"10"></td> </tr> <tr> <td style=3D"font-family:Arial,Helvetica,sans-s=
erif;color:#3c4858;text-align:center"> <span style=3D"color:#3c4858"><div s=
tyle=3D"line-height:24px"><span style=3D"font-size:19px"><span style=3D"col=
or:#00A0DF"><strong>Vous souhaitez <strong><span style=3D"background-color:=
#F9FF00">mesurer et piloter la performance de votre entreprise de mani=C3=
=A8re tr=C3=A8s simple</span></strong>=C2=A0en ayant tout sous les yeux ?<b=
r/> <br/> Vous recherchez un <strong><span style=3D"background-color:#F9FF0=
0">Tableau de bord dynamique et personnalisable</span></strong> avec des in=
dicateurs de performance qui pourraient vous permettre de=C2=A0<strong><spa=
n style=3D"background-color:#F9FF00">suivre toutes les statistiques de votr=
e entreprise</span></strong> ?</strong></span></span>=C2=A0</div> </span> <=
/td> </tr> <tr> <td height=3D"10"></td> </tr> </tbody></table> </th></tr> <=
/tbody></table></td> </tr> </tbody></table> </td> </tr> </tbody></table><!-=
-[if mso]> </td> <![endif]--> <!--[if mso]> </tr> </table> <![endif]--> </d=
iv></td> </tr><tr> <td align=3D"center" valign=3D"top"> <div style=3D"backg=
round-color:#ffffff;border-radius:0px"> <!--[if mso]> <table align=3D"cente=
r" border=3D"0" cellspacing=3D"0" cellpadding=3D"0" width=3D"100%" style=3D=
"width:100%;"> <tr> <![endif]--> <!--[if mso]> <td valign=3D"top" width=3D"=
590" style=3D"width:590px;"> <![endif]--> <table class=3D"rnb-del-min-width=
" width=3D"100%" cellpadding=3D"0" border=3D"0" cellspacing=3D"0" style=3D"=
min-width:590px" name=3D"Layout_1" id=3D"Layout_1"> <tbody><tr> <td class=
=3D"rnb-del-min-width" align=3D"center" valign=3D"top" style=3D"min-width:5=
90px"> <a href=3D"#" name=3D"Layout_1"></a> <table width=3D"100%" border=3D=
"0" cellpadding=3D"0" cellspacing=3D"0" class=3D"rnb-container" bgcolor=3D"=
#ffffff" style=3D"background-color:#ffffff;border-radius:0px;padding-left:2=
0px;padding-right:20px;border-collapse:separate"> <tbody><tr> <td height=3D=
"20" style=3D"font-size:1px;line-height:20px;mso-hide:all">=C2=A0</td> </tr=
> <tr> <td valign=3D"top" class=3D"rnb-container-padding" align=3D"left"> <=
table width=3D"100%" cellpadding=3D"0" border=3D"0" align=3D"center" cellsp=
acing=3D"0"> <tbody><tr> <td valign=3D"top" align=3D"center"> <table cellpa=
dding=3D"0" border=3D"0" align=3D"center" cellspacing=3D"0" class=3D"logo-i=
mg-center"> <tbody><tr> <td valign=3D"middle" align=3D"center" style=3D"lin=
e-height:1px"> <div style=3D"border-top:0px None #9c9c9c;border-right:0px N=
one #9c9c9c;border-bottom:0px None #9c9c9c;border-left:0px None #9c9c9c;dis=
play:inline-block" cellspacing=3D"0" cellpadding=3D"0" border=3D"0"><div><i=
mg width=3D"550" vspace=3D"0" hspace=3D"0" border=3D"0" alt=3D"Centre Ouest=
 Informatique" style=3D"float:left;max-width:550px;display:block" class=3D"=
rnb-logo-img" src=3D"https://img.aei.acropole-expert.com/im/3467908/23d4372=
21d939cf4b0697994c78ef9c1322d6c7911a9d1a71e7e4df0bd467e68.png?e=3D0w6rAcTyu=
cxUZouaKKp222UWuaZHTkd0q-Zps8qsnzmhA0jo1PuyFUx2OYAQCMFtnzAWyblvDMVhVBX8aR93=
hKLnyER23K53dzTiWPH9PTyKy3VVhsKkISib5H8N_-19GgEeUQivuE4Z5QBxD_IlypDxI3jam1-=
K6IOEpTpAsAkoNoMIB5Oq35imxOBrfqnE_3HQLZIdjJJ1mW0cTKyGeDrpGXXSJ_3fqFAtnyw" s=
ib_img_id=3D"10"/></div></div></td> </tr> </tbody></table> </td> </tr> </tb=
ody></table></td> </tr> <tr> <td height=3D"20" style=3D"font-size:1px;line-=
height:20px;mso-hide:all">=C2=A0</td> </tr> </tbody></table> </td> </tr> </=
tbody></table> <!--[if mso]> </td> <![endif]--> <!--[if mso]> </tr> </table=
> <![endif]--> </div></td> </tr><tr> <td align=3D"center" valign=3D"top"> <=
div style=3D"background-color:#ffffff;border-radius:0px"> <!--[if mso]> <ta=
ble align=3D"center" border=3D"0" cellspacing=3D"0" cellpadding=3D"0" width=
=3D"100%" style=3D"width:100%;"> <tr> <![endif]--> <!--[if mso]> <td valign=
=3D"top" width=3D"590" style=3D"width:590px;"> <![endif]--> <table class=3D=
"rnb-del-min-width" width=3D"100%" cellpadding=3D"0" border=3D"0" cellspaci=
ng=3D"0" style=3D"min-width:100%" name=3D"Layout_36"> <tbody><tr> <td class=
=3D"rnb-del-min-width" align=3D"center" valign=3D"top"> <a href=3D"#" name=
=3D"Layout_36"></a> <table width=3D"100%" border=3D"0" cellpadding=3D"0" ce=
llspacing=3D"0" class=3D"rnb-container" bgcolor=3D"#ffffff" style=3D"backgr=
ound-color:#ffffff;padding-left:20px;padding-right:20px;border-collapse:sep=
arate;border-radius:0px;border-bottom:0px none #c8c8c8"> <tbody><tr> <td he=
ight=3D"20" style=3D"font-size:1px;line-height:20px;mso-hide:all">=C2=A0</t=
d> </tr> <tr> <td valign=3D"top" class=3D"rnb-container-padding" align=3D"l=
eft"> <table width=3D"100%" border=3D"0" cellpadding=3D"0" cellspacing=3D"0=
" class=3D"rnb-columns-container"> <tbody><tr> <th class=3D"rnb-force-col" =
style=3D"text-align:left;font-weight:normal;padding-right:0px" valign=3D"to=
p"> <table border=3D"0" valign=3D"top" cellspacing=3D"0" cellpadding=3D"0" =
width=3D"100%" align=3D"left" class=3D"rnb-col-1"> <tbody><tr> <td style=3D=
"font-size:14px;font-family:Arial,Helvetica,sans-serif, sans-serif;color:#3=
c4858"><div style=3D"text-align:center"><span style=3D"font-size:22px"><spa=
n style=3D"color:#00A0DF"><strong>TABLEO est un outil <strong><span style=
=3D"background-color:#F9FF00">pragmatique</span></strong> et <strong><span =
style=3D"background-color:#F9FF00">agile</span></strong> </strong></span></=
span></div> <div style=3D"text-align:center"><strong><span style=3D"color:#=
00A0DF"><span style=3D"font-size:18px"><strong>au service des performances =
de votre entreprise </strong></span></span></strong></div> <div style=3D"te=
xt-align:justify"><strong>=C2=A0</strong></div> <div style=3D"text-align:ju=
stify"><span style=3D"font-size:14px"><strong><span style=3D"color:#000f9f"=
><strong>Il vous permet de <strong><span style=3D"background-color:#F9FF00"=
>piloter votre activit=C3=A9 en construisant et suivant les principaux indi=
cateur</span></strong></strong></span></strong><strong style=3D"background-=
color:transparent"><span style=3D"color:#000f9f"><strong><strong><span styl=
e=3D"background-color:#F9FF00">s de votre entreprise,</span></strong> en re=
qu=C3=AAtant sur la base du fichier de vos =C3=A9critures comptables.</stro=
ng></span></strong></span></div> </td> </tr> </tbody></table> </th></tr> </=
tbody></table></td> </tr> <tr> <td height=3D"20" style=3D"font-size:1px;lin=
e-height:20px;mso-hide:all">=C2=A0</td> </tr> </tbody></table> </td> </tr> =
</tbody></table><!--[if mso]> </td> <![endif]--> <!--[if mso]> </tr> </tabl=
e> <![endif]--> </div></td> </tr><tr> <td align=3D"center" valign=3D"top"> =
<div style=3D"background-color:#ffffff;border-radius:0px"> <!--[if mso]> <t=
able align=3D"center" border=3D"0" cellspacing=3D"0" cellpadding=3D"0" widt=
h=3D"100%" style=3D"width:100%;"> <tr> <![endif]--> <!--[if mso]> <td valig=
n=3D"top" width=3D"590" style=3D"width:590px;"> <![endif]--> <table class=
=3D"rnb-del-min-width" width=3D"100%" cellpadding=3D"0" border=3D"0" cellsp=
acing=3D"0" style=3D"min-width:100%" name=3D"Layout_35"> <tbody><tr> <td cl=
ass=3D"rnb-del-min-width" align=3D"center" valign=3D"top"> <a href=3D"#" na=
me=3D"Layout_35"></a> <table width=3D"100%" border=3D"0" cellpadding=3D"0" =
cellspacing=3D"0" class=3D"rnb-container" bgcolor=3D"#ffffff" style=3D"back=
ground-color:#ffffff;padding-left:20px;padding-right:20px;border-collapse:s=
eparate;border-radius:0px;border-bottom:0px none #c8c8c8"> <tbody><tr> <td =
height=3D"20" style=3D"font-size:1px;line-height:20px;mso-hide:all">=C2=A0<=
/td> </tr> <tr> <td valign=3D"top" class=3D"rnb-container-padding" align=3D=
"left"> <table width=3D"100%" border=3D"0" cellpadding=3D"0" cellspacing=3D=
"0" class=3D"rnb-columns-container"> <tbody><tr> <th class=3D"rnb-force-col=
" style=3D"text-align:left;font-weight:normal;padding-right:0px" valign=3D"=
top"> <table border=3D"0" valign=3D"top" cellspacing=3D"0" cellpadding=3D"0=
" width=3D"100%" align=3D"left" class=3D"rnb-col-1"> <tbody><tr> <td style=
=3D"font-size:14px;font-family:Arial,Helvetica,sans-serif, sans-serif;color=
:#3c4858"><div style=3D"text-align:center"><span style=3D"font-size:22px"><=
span style=3D"color:#00A0DF"><strong>Pourquoi choisir TABLEO ?</strong></sp=
an></span></div> <div style=3D"text-align:center">=C2=A0</div> <div style=
=3D"text-align:center"><span style=3D"font-size:14px"><strong><span style=
=3D"color:#000f9f">Cette solution a =C3=A9t=C3=A9 con=C3=A7ue en =C3=A9troi=
te collaboration avec des experts-comptables</span></strong></span></div> <=
div style=3D"text-align:center">=C2=A0</div> <div style=3D"text-align:justi=
fy"><span style=3D"font-size:14px"><span style=3D"color:#000f9f">Depuis <sp=
an style=3D"color:#000f9f;background-color:#F9FF00"><strong>40 ans</strong>=
</span>, nous faisons partie d=E2=80=99un <span style=3D"color:#000f9f;back=
ground-color:#F9FF00"><strong>groupe familial entrepreneurial ind=C3=A9pend=
ant</strong></span> et avons toujours eu =C3=A0 c=C5=93ur de concevoir, d=
=C3=A9velopper, et d=C3=A9ployer des outils et solutions <strong>simples, d=
urables et robustes</strong>, mais r=C3=A9pondant<strong> parfaitement et</=
strong> <strong>sans fioritures</strong>, aux besoins des utilisateurs du q=
uotidien.</span></span></div> <div style=3D"line-height:16px;text-align:cen=
ter">=C2=A0</div> <div style=3D"text-align:center"><span style=3D"font-size=
:14px"><span style=3D"color:#000f9f">Notre ADN est de nous baser sur <stron=
g>le v=C3=A9cu =C3=A0 la fois d&#39;utilisateurs professionnels</strong> ma=
is surtout d&#39;<strong>utilisateurs comme vous-m=C3=AAme</strong>, <stron=
g>sur la base <span style=3D"color:#000f9f;background-color:#F9FF00">d=E2=
=80=99un r=C3=A9el partenariat</span></strong>.<br/> Nos solutions s&#39;am=
=C3=A9liorent sans cesse par retours d&#39;exp=C3=A9rience.</span></span></=
div> </td> </tr> </tbody></table> </th></tr> </tbody></table></td> </tr> <t=
r> <td height=3D"20" style=3D"font-size:1px;line-height:20px;mso-hide:all">=
=C2=A0</td> </tr> </tbody></table> </td> </tr> </tbody></table><!--[if mso]=
> </td> <![endif]--> <!--[if mso]> </tr> </table> <![endif]--> </div></td> =
</tr><tr> <td align=3D"center" valign=3D"top"> <div style=3D"background-col=
or:#ffffff;border-radius:0px"> <!--[if mso]> <table align=3D"center" border=
=3D"0" cellspacing=3D"0" cellpadding=3D"0" width=3D"100%" style=3D"width:10=
0%;"> <tr> <![endif]--> <!--[if mso]> <td valign=3D"top" width=3D"590" styl=
e=3D"width:590px;"> <![endif]--> <table class=3D"rnb-del-min-width" width=
=3D"100%" cellpadding=3D"0" border=3D"0" cellspacing=3D"0" style=3D"min-wid=
th:100%" name=3D"Layout_26"> <tbody><tr> <td class=3D"rnb-del-min-width" al=
ign=3D"center" valign=3D"top"> <a href=3D"#" name=3D"Layout_26"></a> <table=
 width=3D"100%" border=3D"0" cellpadding=3D"0" cellspacing=3D"0" class=3D"r=
nb-container" bgcolor=3D"#ffffff" style=3D"background-color:#ffffff;padding=
-left:20px;padding-right:20px;border-collapse:separate;border-radius:0px;bo=
rder-bottom:0px none #c8c8c8"> <tbody><tr> <td height=3D"20" style=3D"font-=
size:1px;line-height:20px;mso-hide:all">=C2=A0</td> </tr> <tr> <td valign=
=3D"top" class=3D"rnb-container-padding" align=3D"left"> <table width=3D"10=
0%" border=3D"0" cellpadding=3D"0" cellspacing=3D"0" class=3D"rnb-columns-c=
ontainer"> <tbody><tr> <th class=3D"rnb-force-col" style=3D"text-align:left=
;font-weight:normal;padding-right:0px" valign=3D"top"> <table border=3D"0" =
valign=3D"top" cellspacing=3D"0" cellpadding=3D"0" width=3D"100%" align=3D"=
left" class=3D"rnb-col-1"> <tbody><tr> <td style=3D"font-size:14px;font-fam=
ily:Arial,Helvetica,sans-serif, sans-serif;color:#3c4858"><div style=3D"tex=
t-align:center"> <div style=3D"line-height:24px"><span style=3D"font-size:2=
2px"><span style=3D"color:#00A0DF"><strong>Les avantages de TABLEO :</stron=
g></span></span></div> <div style=3D"line-height:24px">=C2=A0</div> </div> =
<ul> <li style=3D"text-align:left"> <div style=3D"line-height:24px;text-ali=
gn:justify"><span style=3D"font-size:16px"><span style=3D"color:#00A0DF"><s=
trong><strong><span style=3D"background-color:#F9FF00">Gagnez en productivi=
t=C3=A9<span style=3D"font-size:16px"><span style=3D"color:#3C6E71"><strong=
>=E2=80=8B</strong></span></span></span></strong></strong></span></span></d=
iv> <ul> <li style=3D"text-align:left"> <div style=3D"line-height:24px;text=
-align:justify"><span style=3D"font-size:14px"><strong><strong><span style=
=3D"color:#000f9f;background-color:transparent">Plateforme accessible depui=
s n&#39;importe quel navigateur</span></strong></strong></span></div> </li>=
 <li style=3D"text-align:left"> <div style=3D"line-height:20px;text-align:j=
ustify"><span style=3D"font-size:14px"><strong><span style=3D"color:#000f9f=
;background-color:transparent"><strong>Bo=C3=AEte =C3=A0 outil compl=C3=A8t=
e :</strong> </span></strong><span style=3D"color:#000f9f;background-color:=
transparent">indicateurs, graphiques, =E2=80=A6=C2=A0</span></span></div> <=
/li> <li style=3D"text-align:left"> <div style=3D"line-height:20px;text-ali=
gn:justify"><span style=3D"font-size:14px"><strong><strong><span style=3D"c=
olor:#000f9f;background-color:transparent">R=C3=A9cup=C3=A9ration automatiq=
ue des donn=C3=A9es comptables</span></strong></strong></span></div> </li> =
</ul> </li> <li style=3D"text-align:left"> <div style=3D"line-height:24px;t=
ext-align:justify"><strong><span style=3D"font-size:16px"><span style=3D"co=
lor:#00A0DF"><strong><strong><span style=3D"background-color:#F9FF00">Gagne=
z en efficacit=C3=A9</span></strong></strong></span></span></strong></div> =
<ul> <li style=3D"text-align:left"> <div style=3D"line-height:24px;text-ali=
gn:justify"><span style=3D"font-size:14px"><strong><strong><strong><span st=
yle=3D"color:#000f9f;background-color:transparent">G=C3=A9n=C3=A9ration aut=
omatique des tableaux de bord</span></strong></strong></strong></span></div=
> </li> <li style=3D"text-align:left"> <div style=3D"line-height:20px;text-=
align:justify"><span style=3D"font-size:14px"><strong><strong><strong><span=
 style=3D"color:#000f9f;background-color:transparent">Commentaires &amp; an=
alyses historis=C3=A9es</span></strong></strong></strong></span></div> </li=
> <li style=3D"text-align:left"> <div style=3D"line-height:24px;text-align:=
justify"><span style=3D"font-size:14px"><strong><strong><strong><span style=
=3D"color:#000f9f;background-color:transparent">Saisie budg=C3=A9taire simp=
lifi=C3=A9e</span></strong></strong></strong></span></div> </li> </ul> </li=
> <li style=3D"text-align:left"> <div style=3D"line-height:24px;text-align:=
justify"><strong><strong><span style=3D"font-size:16px"><span style=3D"colo=
r:#00A0DF"><strong><strong><span style=3D"background-color:#F9FF00">Pilotez=
 votre activit=C3=A9</span></strong></strong></span></span></strong></stron=
g></div> <ul> <li style=3D"text-align:left"> <div style=3D"line-height:24px=
;text-align:justify"><span style=3D"font-size:14px"><strong><strong><strong=
><strong><span style=3D"color:#000f9f;background-color:transparent">Restitu=
tions graphiques claires et modernes</span></strong></strong></strong></str=
ong></span></div> </li> <li style=3D"text-align:left"> <div style=3D"line-h=
eight:20px;text-align:justify"><span style=3D"font-size:14px"><strong><stro=
ng><strong><span style=3D"color:#000f9f;background-color:transparent"><stro=
ng>Mix des donn=C3=A9es </strong>comptables, extracomptables et budg=C3=A9t=
aires</span></strong></strong></strong></span></div> </li> <li style=3D"tex=
t-align:left"> <div style=3D"line-height:20px;text-align:justify"><span sty=
le=3D"font-size:14px"><strong><strong><strong><span style=3D"color:#000f9f;=
background-color:transparent"><strong>Partage des tableaux de bord </strong=
>en<strong>=C2=A0</strong>mail, PDF, ...</span></strong></strong></strong><=
/span></div> </li> </ul> </li> </ul> <div style=3D"line-height:16px;text-al=
ign:center"> <div style=3D"text-align:center"><br/> <br/> <span style=3D"fo=
nt-size:20px"><span style=3D"color:#00A0DF"><strong>Avec TABLEO, <span styl=
e=3D"font-size:18px">prenez les commandes de votre entreprise</span>, <span=
 style=3D"font-size:23px">pilotez pour mieux performer</span>, =C3=A9change=
r pour aller plus loin.</strong></span></span></div> <div style=3D"text-ali=
gn:center">=C2=A0</div> <div style=3D"text-align:justify">=C2=A0</div> </di=
v> </td> </tr> </tbody></table> </th></tr> </tbody></table></td> </tr> <tr>=
 <td height=3D"20" style=3D"font-size:1px;line-height:20px;mso-hide:all">=
=C2=A0</td> </tr> </tbody></table> </td> </tr> </tbody></table><!--[if mso]=
> </td> <![endif]--> <!--[if mso]> </tr> </table> <![endif]--> </div></td> =
</tr><tr> <td align=3D"center" valign=3D"top"> <div style=3D"background-col=
or:#000f9f;border-radius:0px"> <!--[if mso]> <table align=3D"center" border=
=3D"0" cellspacing=3D"0" cellpadding=3D"0" width=3D"100%" style=3D"width:10=
0%;"> <tr> <![endif]--> <!--[if mso]> <td valign=3D"top" width=3D"590" styl=
e=3D"width:590px;"> <![endif]--> <table class=3D"rnb-del-min-width" width=
=3D"100%" cellpadding=3D"0" border=3D"0" cellspacing=3D"0" style=3D"min-wid=
th:100%" name=3D"Layout_32"> <tbody><tr> <td class=3D"rnb-del-min-width" al=
ign=3D"center" valign=3D"top"> <a href=3D"#" name=3D"Layout_32"></a> <table=
 width=3D"100%" border=3D"0" cellpadding=3D"0" cellspacing=3D"0" class=3D"r=
nb-container" bgcolor=3D"#000f9f" style=3D"background-color:#000f9f;padding=
-left:20px;padding-right:20px;border-collapse:separate;border-radius:0px;bo=
rder-bottom:0px none #c8c8c8"> <tbody><tr> <td height=3D"20" style=3D"font-=
size:1px;line-height:20px;mso-hide:all">=C2=A0</td> </tr> <tr> <td valign=
=3D"top" class=3D"rnb-container-padding" align=3D"left"> <table width=3D"10=
0%" border=3D"0" cellpadding=3D"0" cellspacing=3D"0" class=3D"rnb-columns-c=
ontainer"> <tbody><tr> <th class=3D"rnb-force-col" style=3D"text-align:left=
;font-weight:normal;padding-right:0px" valign=3D"top"> <table border=3D"0" =
valign=3D"top" cellspacing=3D"0" cellpadding=3D"0" width=3D"100%" align=3D"=
left" class=3D"rnb-col-1"> <tbody><tr> <td style=3D"font-size:14px;font-fam=
ily:Arial,Helvetica,sans-serif, sans-serif;color:#3c4858"><div style=3D"tex=
t-align:center"><span style=3D"font-size:16px"><strong><span style=3D"color=
:#FFFFFF">Nous serons ravis de pouvoir vous pr=C3=A9senter notre gamme.</sp=
an></strong></span></div> <div style=3D"text-align:center"><span style=3D"f=
ont-size:16px">=C2=A0</span></div> <div style=3D"text-align:center"><span s=
tyle=3D"font-size:16px"><strong><span style=3D"color:#FFFFFF">Pour cela, no=
us avons programm=C3=A9 3 dates de Webinaires de 30 minutes pour vous pr=C3=
=A9senter =C3=A0 distance les diff=C3=A9rentes fonctionnalit=C3=A9s.</span>=
</strong></span></div> <div style=3D"text-align:center"><span style=3D"font=
-size:16px">=C2=A0</span></div> <div style=3D"text-align:center"><span styl=
e=3D"font-size:16px">=C2=A0</span></div> <div style=3D"text-align:center"><=
span style=3D"font-size:16px"><strong><span style=3D"color:#FFFFFF">Les dat=
es qui vous sont propos=C3=A9es sont les suivantes :</span></strong></span>=
</div> <div style=3D"text-align:center">=C2=A0</div> <div style=3D"text-ali=
gn:center"><span style=3D"font-size:16px"><strong><span style=3D"color:#00A=
0DF">Jeudi 17 F=C3=A9vrier 2022 de 11h00 =C3=A0 11h30</span></strong></span=
></div> <div style=3D"text-align:center"><span style=3D"font-size:16px"><st=
rong><span style=3D"color:#00A0DF">Jeudi 24 Mars 2022 de 11h00 =C3=A0 11h30=
</span></strong></span></div> <div style=3D"text-align:center"><span style=
=3D"font-size:16px"><strong><span style=3D"color:#00A0DF">Jeudi 14 Avril 20=
22 de 11h00 =C3=A0 11h30</span></strong></span></div> </td> </tr> </tbody><=
/table> </th></tr> </tbody></table></td> </tr> <tr> <td height=3D"0" style=
=3D"font-size:1px;line-height:0px;mso-hide:all">=C2=A0</td> </tr> </tbody><=
/table> </td> </tr> </tbody></table><!--[if mso]> </td> <![endif]--> <!--[i=
f mso]> </tr> </table> <![endif]--> </div></td> </tr><tr> <td align=3D"cent=
er" valign=3D"top"> <div style=3D"background-color:#000f9f;border-radius:0p=
x"> <!--[if mso]> <table align=3D"center" border=3D"0" cellspacing=3D"0" ce=
llpadding=3D"0" width=3D"100%" style=3D"width:100%;"> <tr> <![endif]--> <!-=
-[if mso]> <td valign=3D"top" width=3D"590" style=3D"width:590px;"> <![endi=
f]--> <table class=3D"rnb-del-min-width" width=3D"100%" cellpadding=3D"0" b=
order=3D"0" cellspacing=3D"0" style=3D"min-width:590px" name=3D"Layout_43" =
id=3D"Layout_43"> <tbody><tr> <td class=3D"rnb-del-min-width" align=3D"cent=
er" valign=3D"top" style=3D"min-width:590px"> <a href=3D"#" name=3D"Layout_=
43"></a> <table width=3D"100%" border=3D"0" cellpadding=3D"0" cellspacing=
=3D"0" class=3D"mso-button-block rnb-container" style=3D"background-color:#=
000f9f;border-radius:0px;padding-left:20px;padding-right:20px;border-collap=
se:separate"> <tbody><tr> <td height=3D"20" style=3D"font-size:1px;line-hei=
ght:20px;mso-hide:all">=C2=A0</td> </tr> <tr> <td valign=3D"top" class=3D"r=
nb-container-padding" align=3D"left"> <table width=3D"100%" border=3D"0" ce=
llpadding=3D"0" cellspacing=3D"0" class=3D"rnb-columns-container"> <tbody><=
tr> <th class=3D"rnb-force-col" valign=3D"top"> <table border=3D"0" valign=
=3D"top" cellspacing=3D"0" cellpadding=3D"0" width=3D"550" align=3D"center"=
 class=3D"rnb-col-1"> <tbody><tr> <td valign=3D"top"> <table cellpadding=3D=
"0" border=3D"0" align=3D"center" cellspacing=3D"0" class=3D"rnb-btn-col-co=
ntent" style=3D"margin:auto;border-collapse:separate"> <tbody><tr> <td widt=
h=3D"auto" valign=3D"middle" bgcolor=3D"#0092ff" align=3D"center" height=3D=
"40" style=3D"font-size:18px;font-family:Arial,Helvetica,sans-serif;color:#=
ffffff;font-weight:normal;padding-left:20px;padding-right:20px;vertical-ali=
gn:middle;background-color:#0092ff;border-radius:4px;border-top:0px None #0=
00;border-right:0px None #000;border-bottom:0px None #000;border-left:0px N=
one #000"> <span style=3D"color:#ffffff;font-weight:normal"> <a style=3D"te=
xt-decoration:none;color:#ffffff;font-weight:normal" target=3D"_blank" href=
=3D"http://r.aei.acropole-expert.com/mk/cl/f/45ciLqPlN0QTHtJjriyhTKMdqBv-IH=
fmIVtNcafsVOGOGeNPBr2ei5FIFXafzCtuYGyOA49ta9hlzUU5C04kFSZBmrESdWc0webOAR91g=
GUdjt-Zd-oJkmKju7BCpozStrUdGlh8CHK98xs7NGrPGIgEeLhJuzsJ12KNk1MyNiSGSAVKn0YI=
dDUqS9Ye_6wZF9H5WeEp1cPcK-srbQfIROw7bQQ" sib_link_id=3D"0">S&#39;inscrire a=
u Webinaire</a> </span> </td> </tr></tbody></table> </td> </tr> </tbody></t=
able> </th> </tr> </tbody></table></td> </tr> <tr> <td height=3D"20" style=
=3D"font-size:1px;line-height:20px;mso-hide:all">=C2=A0</td> </tr> </tbody>=
</table> </td> </tr> </tbody></table> <!--[if mso]> </td> <![endif]--> <!--=
[if mso]> </tr> </table> <![endif]--> </div></td> </tr><tr> <td align=3D"ce=
nter" valign=3D"top"> <div style=3D"background-color:#ffffff;border-radius:=
0px"> <!--[if mso]> <table align=3D"center" border=3D"0" cellspacing=3D"0" =
cellpadding=3D"0" width=3D"100%" style=3D"width:100%;"> <tr> <![endif]--> <=
!--[if mso]> <td valign=3D"top" width=3D"590" style=3D"width:590px;"> <![en=
dif]--> <table class=3D"rnb-del-min-width" width=3D"100%" cellpadding=3D"0"=
 border=3D"0" cellspacing=3D"0" style=3D"min-width:100%" name=3D"Layout_13"=
> <tbody><tr> <td class=3D"rnb-del-min-width" align=3D"center" valign=3D"to=
p"> <a href=3D"#" name=3D"Layout_13"></a> <table width=3D"100%" border=3D"0=
" cellpadding=3D"0" cellspacing=3D"0" class=3D"rnb-container" bgcolor=3D"#f=
fffff" style=3D"background-color:#ffffff;padding-left:20px;padding-right:20=
px;border-collapse:separate;border-radius:0px;border-bottom:0px none #c8c8c=
8"> <tbody><tr> <td height=3D"20" style=3D"font-size:1px;line-height:20px;m=
so-hide:all">=C2=A0</td> </tr> <tr> <td valign=3D"top" class=3D"rnb-contain=
er-padding" align=3D"left"> <table width=3D"100%" border=3D"0" cellpadding=
=3D"0" cellspacing=3D"0" class=3D"rnb-columns-container"> <tbody><tr> <th c=
lass=3D"rnb-force-col" style=3D"text-align:left;font-weight:normal;padding-=
right:0px" valign=3D"top"> <table border=3D"0" valign=3D"top" cellspacing=
=3D"0" cellpadding=3D"0" width=3D"100%" align=3D"left" class=3D"rnb-col-1">=
 <tbody><tr> <td style=3D"font-size:14px;font-family:Arial,Helvetica,sans-s=
erif, sans-serif;color:#3c4858"><div> <div style=3D"text-align:center"><spa=
n style=3D"font-size:18px"><strong><span style=3D"color:#000f9f">Bien enten=
du, nous serons =C3=A9galement heureux de vous pr=C3=A9senter notre gamme c=
ompl=C3=A8te de solutions et de logiciels :</span></strong></span></div> <p=
 class=3D"MsoNormal"><span style=3D"color:#000f9f"><span style=3D"font-fami=
ly:" times=3D"" new=3D"" roman",serif;mso-fareast-font-family:"times=3D"" n=
ew=3D"" roman";=3D"" mso-fareast-language:fr"=3D""><o:p></o:p></span></span=
></p> </div> </td> </tr> </tbody></table> </th></tr> </tbody></table></td> =
</tr> <tr> <td height=3D"10" style=3D"font-size:1px;line-height:10px;mso-hi=
de:all">=C2=A0</td> </tr> </tbody></table> </td> </tr> </tbody></table><!--=
[if mso]> </td> <![endif]--> <!--[if mso]> </tr> </table> <![endif]--> </di=
v></td> </tr><tr> <td align=3D"center" valign=3D"top"> <div style=3D"backgr=
ound-color:#ffffff"> <!--[if mso]> <table align=3D"center" border=3D"0" cel=
lspacing=3D"0" cellpadding=3D"0" width=3D"100%" style=3D"width:100%;"> <tr>=
 <![endif]--> <!--[if mso]> <td valign=3D"top" width=3D"590" style=3D"width=
:590px;"> <![endif]--> <table class=3D"rnb-del-min-width" width=3D"100%" ce=
llpadding=3D"0" border=3D"0" cellspacing=3D"0" style=3D"min-width:100%;-web=
kit-backface-visibility:hidden;line-height:10px" name=3D"Layout_31" id=3D"L=
ayout_31"> <tbody><tr> <td class=3D"rnb-del-min-width" valign=3D"top" align=
=3D"center" style=3D"min-width:590px"> <a href=3D"#" name=3D"Layout_31"></a=
> <table width=3D"100%" class=3D"rnb-container" cellpadding=3D"0" border=3D=
"0" bgcolor=3D"#ffffff" align=3D"center" cellspacing=3D"0" style=3D"backgro=
und-color:#ffffff"> <tbody><tr> <td valign=3D"top" align=3D"center"> <table=
 cellspacing=3D"0" cellpadding=3D"0" border=3D"0"> <tbody><tr> <td> <div st=
yle=3D"border-radius:5px;width:590;;max-width:2459px !important;border-top:=
0px None #000;border-right:0px None #000;border-bottom:0px None #000;border=
-left:0px None #000;border-collapse:separate;border-radius:0px"> <div><img =
ng-if=3D"col.img.source !=3D 'url'" border=3D"0" hspace=3D"0" vspace=3D"0" =
width=3D"590" class=3D"rnb-header-img" alt=3D"" style=3D"display:block;floa=
t:left;border-radius:5px" src=3D"https://img.aei.acropole-expert.com/im/346=
7908/8eff6b5a33138238037fdda3a898cce8daae67e588a81a2edeec89daa0306674.png?e=
=3DZ-ZFoy1RwcqtlnvBq1MODPk3cq255SFi5UwAIUky8edELPOS8DIWxaVW1_BKnA9rG7-WIDVi=
2rc_Uimj7aN6v5HiPTTsJ7BAnJKyiGlJ6v-2JLgK-FKg8ws90abfTC7vpcii35jWnXzIY3WpBT4=
NMjgdqoI4cL1P8V5zC0sGpNxaatGHXJa2Py_wt9HACtr0WOby4vlwwMV1bLwAJ9hlEfetOgDP6F=
OhXljUfM8" sib_img_id=3D"4"/></div><div style=3D"clear:both"></div> </div><=
/td> </tr> </tbody></table> </td> </tr> </tbody></table> </td> </tr></tbody=
></table> <!--[if mso]> </td> <![endif]--> <!--[if mso]> </tr> </table> <![=
endif]--> </div></td> </tr><tr> <td align=3D"center" valign=3D"top"> <div s=
tyle=3D"background-color:#ffffff;border-radius:0px"> <!--[if mso]> <table a=
lign=3D"center" border=3D"0" cellspacing=3D"0" cellpadding=3D"0" width=3D"1=
00%" style=3D"width:100%;"> <tr> <![endif]--> <!--[if mso]> <td valign=3D"t=
op" width=3D"590" style=3D"width:590px;"> <![endif]--> <table class=3D"rnb-=
del-min-width" width=3D"100%" cellpadding=3D"0" border=3D"0" cellspacing=3D=
"0" style=3D"min-width:100%" name=3D"Layout_29"> <tbody><tr> <td class=3D"r=
nb-del-min-width" align=3D"center" valign=3D"top"> <a href=3D"#" name=3D"La=
yout_29"></a> <table width=3D"100%" border=3D"0" cellpadding=3D"0" cellspac=
ing=3D"0" class=3D"rnb-container" bgcolor=3D"#ffffff" style=3D"background-c=
olor:#ffffff;padding-left:20px;padding-right:20px;border-collapse:separate;=
border-radius:0px;border-bottom:0px none #c8c8c8"> <tbody><tr> <td height=
=3D"20" style=3D"font-size:1px;line-height:20px;mso-hide:all">=C2=A0</td> <=
/tr> <tr> <td valign=3D"top" class=3D"rnb-container-padding" align=3D"left"=
> <table width=3D"100%" border=3D"0" cellpadding=3D"0" cellspacing=3D"0" cl=
ass=3D"rnb-columns-container"> <tbody><tr> <th class=3D"rnb-force-col" styl=
e=3D"text-align:left;font-weight:normal;padding-right:0px" valign=3D"top"> =
<table border=3D"0" valign=3D"top" cellspacing=3D"0" cellpadding=3D"0" widt=
h=3D"100%" align=3D"left" class=3D"rnb-col-1"> <tbody><tr> <td style=3D"fon=
t-size:14px;font-family:Arial,Helvetica,sans-serif, sans-serif;color:#3c485=
8"><div style=3D"text-align:center"><span style=3D"font-size:18px">=C2=A0<s=
pan style=3D"color:#00A0DF;background-color:transparent">Parce que vos pr=
=C3=A9occupations sont aussi les n=C3=B4tres, nous ferons toujours le maxim=
um pour </span><strong style=3D"color:#00A0DF;font-size:18px;background-col=
or:transparent">vous satisfaire</strong><span style=3D"color:#00a0df;backgr=
ound-color:transparent">, en concevant des </span><strong style=3D"color:#0=
0A0DF;font-size:18px;background-color:transparent">solutions performantes</=
strong><span style=3D"color:#00a0df;background-color:transparent"> !</span>=
</span></div> <div style=3D"text-align:center">=C2=A0</div> <div style=3D"t=
ext-align:center">=C2=A0</div> <div style=3D"text-align:center"><strong><sp=
an style=3D"font-size:18px">=C2=A0<font color=3D"#000f9f">Alors, n&#39;atte=
ndez plus en nous contactant au :</font></span></strong></div> <div style=
=3D"text-align:center"><strong><span style=3D"font-size:18px"><font color=
=3D"#000f9f"><span style=3D"background-color:#F9FF00">05 56 69 07 72</span>=
</font></span></strong></div> <div style=3D"text-align:center"><font color=
=3D"#000f9f"><span style=3D"font-size:18px">ou via notre site : <a href=3D"=
http://r.aei.acropole-expert.com/mk/cl/f/8jzz31cZnrL6RDk9eh3DBwcT-tT4mGe5gd=
zVEdwUBvLhI-YND1aOpVvoiyJdmMzwR5Go3r-TVWnD9_W0Lqocn-7zas07JhA-JBQiMxTi8i76l=
vrfE05gztcWbf1in25pjgIwZka6ji4NCP8sqzHXSIVR9YCRq82iGWCP7Oi9mWjCEBQ5s94s0VgU=
cI9CiQKRARGGXzPXZKMR" style=3D"text-decoration:underline;color:#0092ff" sib=
_link_id=3D"1">www.acropole-expert.com</a></span></font></div> <div style=
=3D"text-align:center"><font color=3D"#000f9f"><span style=3D"font-size:18p=
x">ou bien en remplissant le formulaire ci-dessous.</span></font></div> </t=
d> </tr> </tbody></table> </th></tr> </tbody></table></td> </tr> <tr> <td h=
eight=3D"20" style=3D"font-size:1px;line-height:20px;mso-hide:all">=C2=A0</=
td> </tr> </tbody></table> </td> </tr> </tbody></table><!--[if mso]> </td> =
<![endif]--> <!--[if mso]> </tr> </table> <![endif]--> </div></td> </tr><tr=
> <td align=3D"center" valign=3D"top"> <div style=3D"background-color:#ffff=
ff;border-radius:0px"> <!--[if mso]> <table align=3D"center" border=3D"0" c=
ellspacing=3D"0" cellpadding=3D"0" width=3D"100%" style=3D"width:100%;"> <t=
r> <![endif]--> <!--[if mso]> <td valign=3D"top" width=3D"590" style=3D"wid=
th:590px;"> <![endif]--> <table class=3D"rnb-del-min-width" width=3D"100%" =
cellpadding=3D"0" border=3D"0" cellspacing=3D"0" style=3D"min-width:590px" =
name=3D"Layout_30" id=3D"Layout_30"> <tbody><tr> <td class=3D"rnb-del-min-w=
idth" align=3D"center" valign=3D"top" style=3D"min-width:590px"> <a href=3D=
"#" name=3D"Layout_30"></a> <table width=3D"100%" border=3D"0" cellpadding=
=3D"0" cellspacing=3D"0" class=3D"mso-button-block rnb-container" style=3D"=
background-color:#ffffff;border-radius:0px;padding-left:20px;padding-right:=
20px;border-collapse:separate"> <tbody><tr> <td height=3D"20" style=3D"font=
-size:1px;line-height:20px;mso-hide:all">=C2=A0</td> </tr> <tr> <td valign=
=3D"top" class=3D"rnb-container-padding" align=3D"left"> <table width=3D"10=
0%" border=3D"0" cellpadding=3D"0" cellspacing=3D"0" class=3D"rnb-columns-c=
ontainer"> <tbody><tr> <th class=3D"rnb-force-col" valign=3D"top"> <table b=
order=3D"0" valign=3D"top" cellspacing=3D"0" cellpadding=3D"0" width=3D"550=
" align=3D"center" class=3D"rnb-col-1"> <tbody><tr> <td valign=3D"top"> <ta=
ble cellpadding=3D"0" border=3D"0" align=3D"center" cellspacing=3D"0" class=
=3D"rnb-btn-col-content" style=3D"margin:auto;border-collapse:separate"> <t=
body><tr> <td width=3D"auto" valign=3D"middle" bgcolor=3D"#0092ff" align=3D=
"center" height=3D"40" style=3D"font-size:18px;font-family:Arial,Helvetica,=
sans-serif;color:#ffffff;font-weight:normal;padding-left:20px;padding-right=
:20px;vertical-align:middle;background-color:#0092ff;border-radius:4px;bord=
er-top:0px None #000;border-right:0px None #000;border-bottom:0px None #000=
;border-left:0px None #000"> <span style=3D"color:#ffffff;font-weight:norma=
l"> <a style=3D"text-decoration:none;color:#ffffff;font-weight:normal" targ=
et=3D"_blank" href=3D"http://r.aei.acropole-expert.com/mk/cl/f/J5lfVZCMkjlY=
5kgrG1_rvnpELP0T04HmaAx4GVotg2tevgbozCkKODZjp_5QLKo98V6P6CgWtOb3WZTHoJcvzEY=
7_ZeR4eba9cvWJW5iQFQXEl9Jm7EVDyDDpae7OZ9_puvXK13Yaa9bMBC0lETdzQ5x_CglYaJMR7=
rJyL6G6Ae0DWxdzrOAWZiLxg6Sbri6WMB_EaCBgm2flWh9W2rDPZ_mmkzRaaLR_npesxS42uPhV=
Y1B2Wbs6YZEtcgKN1uFMHmpfuVI8Iuyf_jHCOKrwyZ7Kg33APhal2WWHHH17GPGE5ukXJaTbNRR=
SrKIHyzHVKQzLrUc9aYg12Ff1WP1NcJLcCULdzq0nNN_W4UChg" sib_link_id=3D"2">Deman=
der plus d&#39;informations</a> </span> </td> </tr></tbody></table> </td> <=
/tr> </tbody></table> </th> </tr> </tbody></table></td> </tr> <tr> <td heig=
ht=3D"20" style=3D"font-size:1px;line-height:20px;mso-hide:all">=C2=A0</td>=
 </tr> </tbody></table> </td> </tr> </tbody></table> <!--[if mso]> </td> <!=
[endif]--> <!--[if mso]> </tr> </table> <![endif]--> </div></td> </tr><tr> =
<td align=3D"center" valign=3D"top"> <div style=3D"background-color:#ffffff=
"> <table class=3D"rnb-del-min-width rnb-tmpl-width" width=3D"100%" cellpad=
ding=3D"0" border=3D"0" cellspacing=3D"0" style=3D"min-width:590px" name=3D=
"Layout_5" id=3D"Layout_5"> <tbody><tr> <td class=3D"rnb-del-min-width" ali=
gn=3D"center" valign=3D"top" bgcolor=3D"#ffffff" style=3D"min-width:590px;b=
ackground-color:#ffffff"> <a href=3D"#" name=3D"Layout_5"></a> <table width=
=3D"590" class=3D"rnb-container" cellpadding=3D"0" border=3D"0" align=3D"ce=
nter" cellspacing=3D"0"> <tbody><tr> <td height=3D"20" style=3D"font-size:1=
px;line-height:20px;mso-hide:all">=C2=A0</td> </tr> <tr> <td valign=3D"top"=
 class=3D"rnb-container-padding" style=3D"font-size:14px;font-family:Arial,=
Helvetica,sans-serif;color:#888888" align=3D"left"> <table width=3D"100%" b=
order=3D"0" cellpadding=3D"0" cellspacing=3D"0" class=3D"rnb-columns-contai=
ner"> <tbody><tr> <th class=3D"rnb-force-col" style=3D"padding-right:20px;p=
adding-left:20px;mso-padding-alt:0 0 0 20px;font-weight:normal" valign=3D"t=
op"> <table border=3D"0" valign=3D"top" cellspacing=3D"0" cellpadding=3D"0"=
 width=3D"264" align=3D"left" class=3D"rnb-col-2 rnb-social-text-left" styl=
e=3D"border-bottom:0"> <tbody><tr> <td valign=3D"top"> <table cellpadding=
=3D"0" border=3D"0" align=3D"left" cellspacing=3D"0" class=3D"rnb-btn-col-c=
ontent"> <tbody><tr> <td valign=3D"middle" align=3D"left" style=3D"font-siz=
e:14px;font-family:Arial,Helvetica,sans-serif;color:#888888;line-height:16p=
x" class=3D"rnb-text-center"> <div><div><span style=3D"color:#000f9f"><span=
 style=3D"font-size:12px"><strong>ACROPOLE EXPERT INFORMATIQUE</strong><br/=
> <a href=3D"mailto:contact@acropole-expert.com" style=3D"text-decoration:u=
nderline;color:#000f9f">contact@acropole-expert.com</a> </span></span></div=
> <div><span style=3D"color:#000f9f"><span style=3D"font-size:12px"><a href=
=3D"http://r.aei.acropole-expert.com/mk/cl/f/zoepHsVyv5HGqnfFfbjXAkEg3CgOkF=
vlewVaIoRNyFL3qvNFUE8eaQAP-CkrGYDN2UGSa_DKDtCG9Nx7uqi1QWXEVGDXyxmEFYOQkUFb2=
zgnnJLQwRrTYJAP7CDJ5S3iaEA8Mb-6JQOT5yjEb84WTU3W_Ii2a6qNBq9nAagu2tbcN7MD79Xv=
HhSttx5l9lDP3Fw-KR374liT3g" style=3D"text-decoration:underline;color:#000f9=
f" sib_link_id=3D"3">www.acropole-expert.com</a><br/> 119 Avenue Gambetta -=
 17100 Saintes=C2=A0</span></span></div> <div><span style=3D"color:#000f9f"=
><span style=3D"font-size:12px">05 46 74 12 25<br/> 2 rue Jean Pommi=C3=A8s=
 - 33520 Bruges=C2=A0</span></span></div> <div><span style=3D"color:#000f9f=
"><span style=3D"font-size:12px">05 56 69 07 72</span></span></div> </div> =
</td></tr> </tbody></table> </td> </tr> </tbody></table> </th><th ng-if=3D"=
item.text.align=3D=3D'left'" class=3D"rnb-force-col rnb-social-width" valig=
n=3D"top" style=3D"mso-padding-alt:0 20px 0 0;padding-right:15px"> <table b=
order=3D"0" valign=3D"top" cellspacing=3D"0" cellpadding=3D"0" width=3D"246=
" align=3D"right" class=3D"rnb-last-col-2"> <tbody><tr> <td valign=3D"top">=
 <table cellpadding=3D"0" border=3D"0" cellspacing=3D"0" class=3D"rnb-socia=
l-align" style=3D"float:right" align=3D"right"> <tbody><tr> <td valign=3D"m=
iddle" class=3D"rnb-text-center" ng-init=3D"width=3DsetSocialIconsBlockWidt=
h(item)" width=3D"165" align=3D"right"> <div class=3D"rnb-social-center"> <=
table align=3D"left" style=3D"float:left;display:inline-block" border=3D"0"=
 cellpadding=3D"0" cellspacing=3D"0"> <tbody><tr> <td style=3D"padding:0px =
5px 5px 0px;mso-padding-alt:0px 2px 5px 0px" align=3D"left"> <span style=3D=
"color:#ffffff;font-weight:normal"> <a target=3D"_blank" href=3D"http://r.a=
ei.acropole-expert.com/mk/cl/f/fb0pv2-6zocJkFEUuiJJHIId33aM3ynQ0iTSZmXp6N3t=
ZLqySF-al49I4xfIpQyTXGHojGrwIlp2AsMMTz0jgeGmsxCpxEG7FWmwpgWcEyJau-sA8n9eysR=
Lrzp6ADxFWiiOnCUHkMOsawAdBg--jL7qUN97HZjzroKeJ-RHswUEfIR28ebTE6VI3GfMwrHYZO=
4TUSoua5dICe0lsFpkdcm9y68nAmEDNi1DUJmw1ao" sib_link_id=3D"4"><img alt=3D"Fa=
cebook" border=3D"0" hspace=3D"0" vspace=3D"0" style=3D"vertical-align:top"=
 target=3D"_blank" src=3D"https://img.aei.acropole-expert.com/im/3467908/c1=
f3ba8c99cfe47ec3e40cdfab4173d2e091dcb92d24da78000ef4b97d56aadb.png?e=3Dbze3=
oyTaMPEEzrJlZ2JX2dKfIVJk9a36q9Am__p2GvalYLGF1zZk6VRqtva-y6cr_FHfWCQwTOADByS=
mXS70AVg9B4fUL_3QylUayVRGuhaSRKArkD3b-DUYP9ahY7-0JMrmXSrRpHYubdsQLIvMP2wyc1=
qSsAAk_Vi1d9MRBx_2GunNtN7R1qjVKqjuLDmTzZOk9pG_Lw" sib_img_id=3D"5"/></a></s=
pan> </td></tr></tbody></table> </div><div class=3D"rnb-social-center"> <ta=
ble align=3D"left" style=3D"float:left;display:inline-block" border=3D"0" c=
ellpadding=3D"0" cellspacing=3D"0"> <tbody><tr> <td style=3D"padding:0px 5p=
x 5px 0px;mso-padding-alt:0px 2px 5px 0px" align=3D"left"> <span style=3D"c=
olor:#ffffff;font-weight:normal"> <a target=3D"_blank" href=3D"http://r.aei=
.acropole-expert.com/mk/cl/f/m6oyZH5ZbdDMbjYMgvFy3jyJUY0tYIAGoNg1zUHNElaIF7=
LjJvXbPAmp4gEViFvyIqzpr_G6Q8NP7Asfwi26ajBLBbf8cjzKhzoD8ODZaLsfA9uFNHCRj91GP=
SCAOcexxtQxPNagjm0C5K_fPl4TX13ZxqzIRue49-6nVTVbo1hOlmI0Lvsss_3RPVQrPsXcqOJY=
K_FdijjUJ-ehvrHF" sib_link_id=3D"5"><img alt=3D"Twitter" border=3D"0" hspac=
e=3D"0" vspace=3D"0" style=3D"vertical-align:top" target=3D"_blank" src=3D"=
https://img.aei.acropole-expert.com/im/3467908/e88fd93aab1aebf4d38d3cfdbad0=
85c8bb742f6275fc2598daf6ed09b5c3e778.png?e=3D1wY3pYjgwGD9qRNqT6Uc9icsQCYWUA=
ap9DWUeZh0I5imbV27w-N0U7tX48fA_aEwlgJm2mmE1KFmuyRu91JOvb4fuBoi8HV5GEhsCnsj4=
E32-ZLFhRDnnyaKWG9nJsIAAeqZnZq-eFIht_cmjoKaJ1Uxp4-hT6x6kcSusc7G_FsCNk1Q6G2Z=
KraCRKy1AzHezizh580iXg" sib_img_id=3D"6"/></a></span> </td></tr></tbody></t=
able> </div><div class=3D"rnb-social-center"> <table align=3D"left" style=
=3D"float:left;display:inline-block" border=3D"0" cellpadding=3D"0" cellspa=
cing=3D"0"> <tbody><tr> <td style=3D"padding:0px 5px 5px 0px;mso-padding-al=
t:0px 2px 5px 0px" align=3D"left"> <span style=3D"color:#ffffff;font-weight=
:normal"> <a target=3D"_blank" href=3D"http://r.aei.acropole-expert.com/mk/=
cl/f/6BeCbNcNTWDGgqseYP-eYJ0x1QINcwIGdJAcYqj-zAJ507dHryMU0LJabIWvAJMJkmXX8Y=
oijOFNh6SGAcq89t0pwARPK3mVXy6orsP0u7HiwaxkoTN85ickRiHC7u5MCiUTQe5Tw-nXEJKpl=
psQ-d2hVLwIM2QWYReWoDA469Q6KEmPmQN3u9dNegu6kR3OKiCsGneoBa1E_kdHARfgQAOvbG_1=
7xZaLhTDA94nv72Y6MBCMtsf6g7aTreOfuY" sib_link_id=3D"6"><img alt=3D"LinkedIn=
" border=3D"0" hspace=3D"0" vspace=3D"0" style=3D"vertical-align:top" targe=
t=3D"_blank" src=3D"https://img.aei.acropole-expert.com/im/3467908/c62b94fb=
f4debc937a5e78fc57aa1349f601f6a36493d3505ca133be96e1d7c6.png?e=3DdRy24hEXcD=
MWtgbXXREMJUW1DjZRoLPRCi0L1KYmwnQbVywB-MP-OZ9i8eQwi5GNqVSwi54EED9ICeQSubKeO=
rUpECK7fGw7Id8jVIXfmFAT7LfBmrSrNBAIFQSSQ7AtCpJzsV0d_ucr6nd46qI_yfreZah8C-in=
wN7zerAl5FT2GXNWleSRccSti_fgBmy7rKX-JlTTxw" sib_img_id=3D"7"/></a></span> <=
/td></tr></tbody></table> </div><div class=3D"rnb-social-center"> <table al=
ign=3D"left" style=3D"float:left;display:inline-block" border=3D"0" cellpad=
ding=3D"0" cellspacing=3D"0"> <tbody><tr> <td style=3D"padding:0px 5px 5px =
0px;mso-padding-alt:0px 2px 5px 0px" align=3D"left"> <span style=3D"color:#=
ffffff;font-weight:normal"> <a target=3D"_blank" href=3D"http://r.aei.acrop=
ole-expert.com/mk/cl/f/J8NWUw-SRS2c8cgSkOpNToGrxqinvTgxW-2LefXYoZip_vL4Q93i=
wMTRdEt3K7EVgQc36BEd9Gycsx2ZKbD5VzWTUQvFxlmA3W3gJ-abN_BZHQvD7_TobYFHvx4CCcE=
2moE3EJ5W3ZkSfnQqaYO7hLPYFpNR5f0qc1j3T0cySLw9YE-8nDJPmg94pdTARxik3XmsJICBbY=
2PYm1xKOts4pDKjlibHxUuau-7ClTx2KC9Ac2Zx5kJ" sib_link_id=3D"7"><img alt=3D"Y=
outube" border=3D"0" hspace=3D"0" vspace=3D"0" style=3D"vertical-align:top"=
 target=3D"_blank" src=3D"https://img.aei.acropole-expert.com/im/3467908/75=
be4c353563822bc5f7083db1bf0ad4c620d90c37d24e57aea7ff0587fb58fc.png?e=3DByux=
S3TPGPs_rsyCSWr9b0TeNfKcl873dwp82p34WnoNytgJjJCbCumvpxmqKAeVWPb4s1LPDRWRfxi=
JsxgwMUVKoTkEqRzZEnZu44pHQW-2H3GQkdGMFwty3DKWCXMKhSFBPTNlWx2ZK7AOjTMFu_d5na=
tQH7Aihsi6rOUv8Tvk-qLAyM0J7qpwsS2Q1cU9SBOzCXhang" sib_img_id=3D"8"/></a></s=
pan> </td></tr></tbody></table> </div></td> </tr> </tbody></table> </td> </=
tr> </tbody></table> </th></tr> </tbody></table></td> </tr> <tr> <td height=
=3D"20" style=3D"font-size:1px;line-height:20px;mso-hide:all">=C2=A0</td> <=
/tr> </tbody></table> </td> </tr></tbody></table> </div></td> </tr><tr> <td=
 align=3D"center" valign=3D"top"> <div style=3D"background-color:#ffffff"> =
<!--[if mso]> <table align=3D"center" border=3D"0" cellspacing=3D"0" cellpa=
dding=3D"0" width=3D"100%" style=3D"width:100%;"> <tr> <![endif]--> <!--[if=
 mso]> <td valign=3D"top" width=3D"590" style=3D"width:590px;"> <![endif]--=
> <table class=3D"rnb-del-min-width" width=3D"100%" cellpadding=3D"0" borde=
r=3D"0" cellspacing=3D"0" style=3D"min-width:100%;-webkit-backface-visibili=
ty:hidden;line-height:10px" name=3D"Layout_9" id=3D"Layout_9"> <tbody><tr> =
<td class=3D"rnb-del-min-width" valign=3D"top" align=3D"center" style=3D"mi=
n-width:590px"> <a href=3D"#" name=3D"Layout_9"></a> <table width=3D"100%" =
class=3D"rnb-container" cellpadding=3D"0" border=3D"0" bgcolor=3D"#ffffff" =
align=3D"center" cellspacing=3D"0" style=3D"background-color:#ffffff"> <tbo=
dy><tr> <td valign=3D"top" align=3D"center"> <table cellspacing=3D"0" cellp=
adding=3D"0" border=3D"0"> <tbody><tr> <td> <div style=3D"border-radius:5px=
;width:590;;max-width:600px !important;border-top:0px None #000;border-righ=
t:0px None #000;border-bottom:0px None #000;border-left:0px None #000;borde=
r-collapse:separate;border-radius:0px"> <div><img ng-if=3D"col.img.source !=
=3D 'url'" border=3D"0" hspace=3D"0" vspace=3D"0" width=3D"590" class=3D"rn=
b-header-img" alt=3D"" style=3D"display:block;float:left;border-radius:5px"=
 src=3D"https://img.aei.acropole-expert.com/im/3467908/26c49168e2833ef2675c=
5f7f84dcdbf52c890ef5b9b84d391b52ce483a1fefde.jpg?e=3DWmKQjj6OJQTItJg0FhMd2C=
-2XfdQqdOrAtgphY0yqqeiuwzRtGPWM-jFoYQ35eL290vzBFmQ7M8GlQh5HIuS1JxAn5ujf3mbt=
7zeyHNK4154eUAACuQpkccSepQvjxid6ncNP5LoCFEnoqRANimYEPRlMTJ0pg8MAFoDrERHo1OT=
VXpxO2SeRDoUEa2DBg85RMDsHHndAzoVVPNCKCg03i_aGuryXSmRT0WXESE" sib_img_id=3D"=
9"/></div><div style=3D"clear:both"></div> </div></td> </tr> </tbody></tabl=
e> </td> </tr> </tbody></table> </td> </tr></tbody></table> <!--[if mso]> <=
/td> <![endif]--> <!--[if mso]> </tr> </table> <![endif]--> </div></td> </t=
r><tr> <td align=3D"center" valign=3D"top"> <table class=3D"rnb-del-min-wid=
th" width=3D"100%" cellpadding=3D"0" border=3D"0" cellspacing=3D"0" style=
=3D"min-width:590px" name=3D"Layout_" id=3D"Layout_"> <tbody><tr> <td class=
=3D"rnb-del-min-width" valign=3D"top" align=3D"center" style=3D"min-width:5=
90px"> <a href=3D"#" name=3D"Layout_"></a> <table width=3D"100%" cellpaddin=
g=3D"0" border=3D"0" height=3D"30" cellspacing=3D"0"> <tbody><tr> <td valig=
n=3D"top" height=3D"30"> <img width=3D"20" height=3D"30" style=3D"display:b=
lock;max-height:30px;max-width:20px" alt=3D"" src=3D"https://img.aei.acropo=
le-expert.com/im/3467908/15fd9f264001efa0668072cabf04073d203e1c628b776e8750=
6daf3661b832d6.gif?e=3DpvhTP7qTqV-QfYNAEIdPw2DLOApYCfmfch18xk0L8WgUfTTZWqrZ=
-jPd17PgvE9nbOyPPbxL50i-plghmd1QJBT0r0b_3Ezr_LUMxdGLGEV_KwVrxM8dRPKlUXVlm1-=
9DlIGODsVBZ9aqQxG3D45cfXwk1UabfTzezfsVdxDNvFWk65ErN54d5qTydV8" sib_img_id=
=3D"0"/> </td> </tr> </tbody></table> </td> </tr> </tbody></table> </td> </=
tr><tr> <td align=3D"center" valign=3D"top"> <div style=3D"background-color=
:#f9fafc"> <table class=3D"rnb-del-min-width rnb-tmpl-width" width=3D"100%"=
 cellpadding=3D"0" border=3D"0" cellspacing=3D"0" style=3D"min-width:590px"=
 name=3D"Layout_6" id=3D"Layout_6"> <tbody><tr> <td class=3D"rnb-del-min-wi=
dth" align=3D"center" valign=3D"top" bgcolor=3D"#f9fafc" style=3D"min-width=
:590px;background-color:#f9fafc;text-align:center"> <a href=3D"#" name=3D"L=
ayout_6"></a> <table width=3D"590" class=3D"rnb-container" cellpadding=3D"0=
" border=3D"0" align=3D"center" cellspacing=3D"0" bgcolor=3D"#f9fafc" style=
=3D"padding-right:20px;padding-left:20px;background-color:#f9fafc"> <tbody>=
<tr> <td height=3D"10" style=3D"font-size:1px;line-height:1px;mso-hide:all"=
>=C2=A0</td> </tr> <tr> <td> <div style=3D"font-size:14px;color:#888888;fon=
t-weight:normal;text-align:center;font-family:Arial,Helvetica,sans-serif">C=
et e-mail a =C3=A9t=C3=A9 envoy=C3=A9 =C3=A0 dm-devel@redhat.com<div>Vous a=
vez re=C3=A7u cet email car vous vous =C3=AAtes inscrit sur Centre Ouest In=
formatique.</div><div>=C2=A0</div></div> <div style=3D"display:block;text-a=
lign:center"> <span style=3D"font-size:14px;font-weight:normal;display:inli=
ne-block;text-align:center;font-family:Arial,Helvetica,sans-serif"> <a styl=
e=3D"text-decoration:underline;color:#666666;font-size:14px;font-weight:nor=
mal;font-family:Arial,Helvetica,sans-serif" target=3D"_blank" href=3D"http:=
//r.aei.acropole-expert.com/mk/un/r_49Jtk8cFbCmOOwoYQcsFQZ6BAs5ixSd6EBsV1kL=
HuiQZ_jE5kM-ZMKWV3_DwJAVC4eKw3Qpa90QV0C7zQBlwotTjV0MpXAdrxHviVZE759v4hLw4h3=
2OX4KIt-oJJZ_ZfMPqQJCK6iMYnGCqbwlY8fr9gfgXmkbiJHpvk1P1WD">Se d=C3=A9sinscri=
re</a></span> </div> </td></tr> <tr> <td height=3D"10" style=3D"font-size:1=
px;line-height:1px;mso-hide:all">=C2=A0</td> </tr> </tbody></table> </td> <=
/tr> </tbody></table> </div></td> </tr><tr> <td align=3D"center" valign=3D"=
top"> <div style=3D"background-color:#f9fafc"> <table class=3D"rnb-del-min-=
width rnb-tmpl-width" width=3D"100%" cellpadding=3D"0" border=3D"0" cellspa=
cing=3D"0" style=3D"min-width:590px" name=3D"Layout_7" id=3D"Layout_7"> <tb=
ody><tr> <td class=3D"rnb-del-min-width" align=3D"center" valign=3D"top" st=
yle=3D"min-width:590px"> <a href=3D"#" name=3D"Layout_7"></a> <table width=
=3D"100%" cellpadding=3D"0" border=3D"0" align=3D"center" cellspacing=3D"0"=
 bgcolor=3D"#f9fafc" style=3D"padding-right:20px;padding-left:20px;backgrou=
nd-color:#f9fafc"> <tbody><tr> <td height=3D"20" style=3D"font-size:1px;lin=
e-height:20px;mso-hide:all">=C2=A0</td> </tr> <tr> <td style=3D"font-size:1=
4px;color:#888888;font-weight:normal;text-align:center;font-family:Arial,He=
lvetica,sans-serif"> <div>=C2=A9 2021 Centre Ouest Informatique</div> </td>=
</tr> <tr> <td height=3D"20" style=3D"font-size:1px;line-height:20px;mso-hi=
de:all">=C2=A0</td> </tr> </tbody></table> </td> </tr> </tbody></table> </d=
iv></td> </tr></tbody></table> <!--[if gte mso 9]> </td> </tr> </table> <![=
endif]--> </td> </tr> </tbody></table> <div><img width=3D"1" height=3D"1" s=
rc=3D"http://r.aei.acropole-expert.com/mk/op/GFerD0aJJS0R-ia9nzrVxGU5Va0OvA=
iKsTOIVkMX1ZDW7hmTbLRbk6hp947CJDkx45K56Kpjkf88uQNmVUIC6-qnftPCbxLoqX5DlzavR=
QqTSPrb-cZq9UHXezR0x5zlAPkC7rDFLQY3"/></div> </body></html>

---------?=_68678-9548238861268--

--===============5642147019853032299==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel
--===============5642147019853032299==--

