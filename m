From: "M.H. Tsai" <mingnus@gmail.com>
Subject: thin_check doesn't use data space map to open data
	mapping tree
Date: Mon, 6 Apr 2015 22:18:45 +0800
Message-ID: <CAAYit8RNtGwdSMWfD2ve8hS9iUPj+v49Gg+whnNp-WQHpB4GNw@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0431601401450508854=="
Return-path: <dm-devel-bounces@redhat.com>
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

--===============0431601401450508854==
Content-Type: multipart/alternative; boundary=001a1134bd80d5b25f05130ef91f

--001a1134bd80d5b25f05130ef91f
Content-Type: text/plain; charset=UTF-8

Hi All,

I found two doubtful points in thin-provisioning-tools,
which might need your help to provide some opinions:

1. thin_check doesn't open metadata and data space maps.
   It uses the core space_map to open the mapping_tree,
   instead of the data space map. Is that legal?
   (Although block_time_ref_counter was never used during tree traversal)

2. Class mapping_tree_detail::ll_damage_visitor should not be used to
traverse
   a single_mapping_tree. This class was designed for two-level data
mapping tree,
   or the top-level data mapping tree (i.e., mapping_tree and dev_tree
types).
   It generates missing_devices while visiting a damage with
zero-length-path,
   which is not semantically suitable for single_mapping_tree.


Thanks,
Ming-Hung Tsai

--001a1134bd80d5b25f05130ef91f
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div>Hi All,</div><div><br></div><div>I found two doubtful=
 points in thin-provisioning-tools,</div><div>which might need your help to=
 provide some opinions:</div><div><br></div><div>1. thin_check doesn&#39;t =
open metadata and data space maps.</div><div>=C2=A0 =C2=A0It uses the core =
space_map to open the mapping_tree,</div><div>=C2=A0 =C2=A0instead of the d=
ata space map. Is that legal?</div><div>=C2=A0 =C2=A0(Although block_time_r=
ef_counter was never used during tree traversal)</div><div><br></div><div>2=
. Class mapping_tree_detail::ll_damage_visitor should not be used to traver=
se</div><div>=C2=A0 =C2=A0a single_mapping_tree. This class was designed fo=
r two-level data mapping tree,</div><div>=C2=A0 =C2=A0or the top-level data=
 mapping tree (i.e., mapping_tree and dev_tree types).</div><div>=C2=A0 =C2=
=A0It generates missing_devices while visiting a damage with zero-length-pa=
th,</div><div>=C2=A0 =C2=A0which is not semantically suitable for single_ma=
pping_tree.</div><div><br></div><div><br></div><div><span style=3D"font-siz=
e:14px">Thanks,</span><br></div><div>Ming-Hung Tsai</div></div>

--001a1134bd80d5b25f05130ef91f--


--===============0431601401450508854==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0431601401450508854==--
