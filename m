From: "David Kwon (=?EUC-KR?B?sce/+Mir?=)" <wonhong.kwon@lge.com>
Subject: Re: dm: add swap_slot_free_notify handler
Date: Tue, 4 Oct 2016 07:53:02 +0900
Message-ID: <D4191022.4934%wonhong.kwon@lge.com>
References: <20160922001428.GA12676@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1846182594988227798=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20160922001428.GA12676@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: gunho.lee@lge.com, dm-devel@redhat.com, agk@redhat.com
List-Id: dm-devel.ids

--===============1846182594988227798==
Content-Type: multipart/alternative; boundary="B_3558412387_24745221"

--B_3558412387_24745221
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="EUC-KR"

Understood. Now I=A1=AFm developing some target which is using this interface
locally, and I=A1=AFll send this patch again when I push this target to upstrea=
m.

From:  Mike Snitzer <snitzer@redhat.com>
Date:  2016=B3=E2 9=BF=F9 22=C0=CF =B8=F1=BF=E4=C0=CF =BF=C0=C0=FC 9:14
To:  David <wonhong.kwon@lge.com>
Cc:  <agk@redhat.com>, <dm-devel@redhat.com>, '=C0=CC=B0=C7=C8=A3' <gunho.lee@lge.com>
Subject:  Re: dm: add swap_slot_free_notify handler

> On Wed, Sep 21 2016 at  7:09pm -0400,
> Wonhong Kwon <wonhong.kwon@lge.com> wrote:
>=20
>>  swap_slot_free_notify callback has been added to block_device_operation=
s to
>>  allow freeing memory allocated by RAM-based swap device like zram or zs=
wap
>>  more aggressively.
>> =20
>>  In case of device mapper, it is also required if mapped target is being
>>  used as swap device and it uses some in-memory metadata for swap entrie=
s.
>>  This patch introduces swap_slot_free_notify callback into dm_blk_ops an=
d
>>  target device can implement its own handler to handle this via
>>  slot_free_notify in target_type.
>> =20
>>  Signed-off-by: Wonhong Kwon <wonhong.kwon@lge.com>
>=20
> This change to DM core only makes sense once we have an upstream DM
> target that implements slot_free_notify hook.
>=20



--B_3558412387_24745221
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset="EUC-KR"

<html><head></head><body style=3D"word-wrap: break-word; -webkit-nbsp-mode: s=
pace; -webkit-line-break: after-white-space; color: rgb(0, 0, 0); font-size:=
 14px; font-family: Calibri, sans-serif;"><div>Understood. Now I&#8217;m dev=
eloping some target which is using this interface locally, and I&#8217;ll se=
nd this patch again when I push this target to upstream.</div><div><br></div=
><span id=3D"OLK_SRC_BODY_SECTION"><div style=3D"font-family:Calibri; font-size:=
11pt; text-align:left; color:black; BORDER-BOTTOM: medium none; BORDER-LEFT:=
 medium none; PADDING-BOTTOM: 0in; PADDING-LEFT: 0in; PADDING-RIGHT: 0in; BO=
RDER-TOP: #b5c4df 1pt solid; BORDER-RIGHT: medium none; PADDING-TOP: 3pt"><s=
pan style=3D"font-weight:bold">From: </span> Mike Snitzer &lt;<a href=3D"mailto:=
snitzer@redhat.com">snitzer@redhat.com</a>&gt;<br><span style=3D"font-weight:b=
old">Date: </span> 2016=B3=E2 9=BF=F9 22=C0=CF =B8=F1=BF=E4=C0=CF =BF=C0=C0=FC 9:14<br><span style=3D"font-wei=
ght:bold">To: </span> David &lt;<a href=3D"mailto:wonhong.kwon@lge.com">wonhon=
g.kwon@lge.com</a>&gt;<br><span style=3D"font-weight:bold">Cc: </span> &lt;<a =
href=3D"mailto:agk@redhat.com">agk@redhat.com</a>&gt;, &lt;<a href=3D"mailto:dm-=
devel@redhat.com">dm-devel@redhat.com</a>&gt;, '=C0=CC=B0=C7=C8=A3' &lt;<a href=3D"mailto:=
gunho.lee@lge.com">gunho.lee@lge.com</a>&gt;<br><span style=3D"font-weight:bol=
d">Subject: </span> Re: dm: add swap_slot_free_notify handler<br></div><div>=
<br></div><blockquote id=3D"MAC_OUTLOOK_ATTRIBUTION_BLOCKQUOTE" style=3D"BORDER-=
LEFT: #b5c4df 5 solid; PADDING:0 0 0 5; MARGIN:0 0 0 5;"><div><div><div>On W=
ed, Sep 21 2016 at&nbsp;&nbsp;7:09pm -0400,</div><div>Wonhong Kwon &lt;<a hr=
ef=3D"mailto:wonhong.kwon@lge.com">wonhong.kwon@lge.com</a>&gt; wrote:</div><d=
iv><br></div><blockquote id=3D"MAC_OUTLOOK_ATTRIBUTION_BLOCKQUOTE" style=3D"BORD=
ER-LEFT: #b5c4df 5 solid; PADDING:0 0 0 5; MARGIN:0 0 0 5;"><div> swap_slot_=
free_notify callback has been added to block_device_operations to</div><div>=
 allow freeing memory allocated by RAM-based swap device like zram or zswap<=
/div><div> more aggressively.</div><div> </div><div> In case of device mappe=
r, it is also required if mapped target is being</div><div> used as swap dev=
ice and it uses some in-memory metadata for swap entries.</div><div> This pa=
tch introduces swap_slot_free_notify callback into dm_blk_ops and</div><div>=
 target device can implement its own handler to handle this via</div><div> s=
lot_free_notify in target_type.</div><div> </div><div> Signed-off-by: Wonhon=
g Kwon &lt;<a href=3D"mailto:wonhong.kwon@lge.com">wonhong.kwon@lge.com</a>&gt=
;</div></blockquote><div><br></div><div>This change to DM core only makes se=
nse once we have an upstream DM</div><div>target that implements slot_free_n=
otify hook.</div><div><br></div></div></div></blockquote></span></body></htm=
l>

--B_3558412387_24745221--


--===============1846182594988227798==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1846182594988227798==--
