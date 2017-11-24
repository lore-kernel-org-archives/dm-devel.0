From: "monty_pavel@sina.com" <monty_pavel@sina.com>
Subject: [PATCH] dm thin: fix NULL pointer exception caused by
	two concurrent "vgchange -ay -K <vg name>" processes.
Date: Fri, 24 Nov 2017 16:59:13 +0800
Message-ID: <201711241659129513254@sina.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============8760186108281885390=="
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
To: dm-devel <dm-devel@redhat.com>
List-Id: dm-devel.ids


This is a multi-part message in MIME format.

--===============8760186108281885390==
Content-Type: multipart/alternative;
	boundary="----=_001_NextPart652568046867_=----"


This is a multi-part message in MIME format.

------=_001_NextPart652568046867_=----
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: base64

V2UgZ290IGEgTlVMTCBwb2ludGVyIGV4Y2VwdGlvbiB3aGVuIHRlc3RpbmcgdGhlIHR3byBjb25j
dXJyZW50DQogInZnY2hhbmdlIC1heSAtSyA8dmcgbmFtZT4iLg0KcGFuaWMgY2FsbCB0cmFjZToN
CiBQSUQ6IDI1OTkyIFRBU0s6IGZmZmY4ODNjZDdkMjM1MDAgQ1BVOiA0IENPTU1BTkQ6ICJ2Z2No
YW5nZSINCiAgIzAgW2ZmZmY4ODNjZDc0M2Q2MDBdIG1hY2hpbmVfa2V4ZWMgYXQgZmZmZmZmZmY4
MTAzOGZhOQ0KICAwMDAwMDAxIFtmZmZmODgzY2Q3NDNkNjYwXSBjcmFzaF9rZXhlYyBhdCBmZmZm
ZmZmZjgxMGM1OTkyDQogIDAwMDAwMDIgW2ZmZmY4ODNjZDc0M2Q3MzBdIG9vcHNfZW5kIGF0IGZm
ZmZmZmZmODE1MTVjOTANCiAgMDAwMDAwMyBbZmZmZjg4M2NkNzQzZDc2MF0gbm9fY29udGV4dCBh
dCBmZmZmZmZmZjgxMDQ5ZjFiDQogIDAwMDAwMDQgW2ZmZmY4ODNjZDc0M2Q3YjBdIF9fYmFkX2Fy
ZWFfbm9zZW1hcGhvcmUgYXQgZmZmZmZmZmY4MTA0YTFhNQ0KICAwMDAwMDA1IFtmZmZmODgzY2Q3
NDNkODAwXSBiYWRfYXJlYSBhdCBmZmZmZmZmZjgxMDRhMmNlDQogIDAwMDAwMDYgW2ZmZmY4ODNj
ZDc0M2Q4MzBdIF9fZG9fcGFnZV9mYXVsdCBhdCBmZmZmZmZmZjgxMDRhYTZmDQogIDAwMDAwMDcg
W2ZmZmY4ODNjZDc0M2Q5NTBdIGRvX3BhZ2VfZmF1bHQgYXQgZmZmZmZmZmY4MTUxN2JhZQ0KICAw
MDAwMDA4IFtmZmZmODgzY2Q3NDNkOTgwXSBwYWdlX2ZhdWx0IGF0IGZmZmZmZmZmODE1MTRmOTUN
CiAgICAgW2V4Y2VwdGlvbiBSSVA6IGttZW1fY2FjaGVfYWxsb2MrMTA4XQ0KICAgICBSSVA6IGZm
ZmZmZmZmODExNmVmM2MgUlNQOiBmZmZmODgzY2Q3NDNkYTM4IFJGTEFHUzogMDAwMTAwNDYNCiAg
ICAgUkFYOiAwMDAwMDAwMDAwMDAwMDA0IFJCWDogZmZmZmZmZmY4MTEyMWI5MCBSQ1g6IGZmZmY4
ODFiZjFlNzhjYzANCiAgICAgUkRYOiAwMDAwMDAwMDAwMDAwMDAwIFJTSTogMDAwMDAwMDAwMDAw
MDBkMCBSREk6IDAwMDAwMDAwMDAwMDAwMDANCiAgICAgUkJQOiBmZmZmODgzY2Q3NDNkYTY4IFI4
OiBmZmZmODgxYmYxYTRlYjAwIFI5OiAwMDAwMDAwMDgwMDQyMDAwDQogICAgIFIxMDogMDAwMDAw
MDAwMDAwMjAwMCBSMTE6IDAwMDAwMDAwMDAwMDAwMDAgUjEyOiAwMDAwMDAwMDAwMDAwMGQwDQog
ICAgIFIxMzogMDAwMDAwMDAwMDAwMDAwMCBSMTQ6IDAwMDAwMDAwMDAwMDAwZDAgUjE1OiAwMDAw
MDAwMDAwMDAwMjQ2DQogICAgIE9SSUdfUkFYOiBmZmZmZmZmZmZmZmZmZmZmIENTOiAwMDEwIFNT
OiAwMDE4DQogIDAwMDAwMDkgW2ZmZmY4ODNjZDc0M2RhNzBdIG1lbXBvb2xfYWxsb2Nfc2xhYiBh
dCBmZmZmZmZmZjgxMTIxYmE1DQogMDAwMDAxMCBbZmZmZjg4M2NkNzQzZGE4MF0gbWVtcG9vbF9j
cmVhdGVfbm9kZSBhdCBmZmZmZmZmZjgxMTIyMDgzDQogMDAwMDAxMSBbZmZmZjg4M2NkNzQzZGFk
MF0gbWVtcG9vbF9jcmVhdGUgYXQgZmZmZmZmZmY4MTEyMjBmNA0KIDAwMDAwMTIgW2ZmZmY4ODNj
ZDc0M2RhZTBdIHBvb2xfY3RyIGF0IGZmZmZmZmZmYTA4ZGUwNDkgW2RtX3RoaW5fcG9vbF0NCiAw
MDAwMDEzIFtmZmZmODgzY2Q3NDNkYmQwXSBkbV90YWJsZV9hZGRfdGFyZ2V0IGF0IGZmZmZmZmZm
YTAwMDVmMmYgW2RtX21vZF0NCiAwMDAwMDE0IFtmZmZmODgzY2Q3NDNkYzMwXSB0YWJsZV9sb2Fk
IGF0IGZmZmZmZmZmYTAwMDhiYTkgW2RtX21vZF0NCiAwMDAwMDE1IFtmZmZmODgzY2Q3NDNkYzkw
XSBjdGxfaW9jdGwgYXQgZmZmZmZmZmZhMDAwOWRjNCBbZG1fbW9kXQ0KIHRoaXMgYnVnJ3Mgc2Nl
bmNlIGlzIGFzIGZvbGxvd3M6DQogcHJvY2VzcyBBKHZnY2hhbmdlIC1heSAtSyk6DQogIGEuIHNl
bmQgRE1fTElTVF9WRVJTSU9OU19DTUQgaW9jdGw7DQogIGIuIHBvb2xfdGFyZ2V0IG5vdCByZWdp
c3RlcmVkOw0KICBjLiBtb2Rwcm9iZSBkbV90aGluX3Bvb2wgYW5kIHdhaXQgdW50aWwgZW5kLg0K
IHByb2Nlc3MgQih2Z2NoYW5nZSAtYXkgLUspOg0KICBhLiBzZW5kIERNX0xJU1RfVkVSU0lPTlNf
Q01EIGlvY3RsOw0KICBiLiBwb29sX3RhcmdldCByZWdpc3RlcmVkOw0KICBjLiB0YWJsZV9sb2Fk
LT5kbV90YWJsZV9hZGRfdGFyZ2V0LT5wb29sX2N0cjsNCiAgZC4gX25ld19tYXBwaW5nX2NhY2hl
IGlzIE5VTEwgYW5kIHBhbmljLg0KIG5vdGU6DQogIDEuIHByb2Nlc3MgQSBhbmQgcHJvY2VzcyBC
IGFyZSB0d28gY29uY3VycmVudCBwcm9jZXNzZXMuDQogIDIuIHBvb2xfdGFyZ2V0IGNhbiBiZSBk
ZXRlY3RlZCBieSBwcm9jZXNzIEIgYnV0DQogIF9uZXdfbWFwcGluZ19jYWNoZSBpbml0aWFsaXph
dGlvbiBoYXMgbm90IGVuZGVkLg0KIEFsbCB0aGF0IHdlIG5lZWQgZG8gaXMgdG8gZW5zdXJlIHBv
b2xfdGFyZ2V0IHJlZ2lzdGVyaW5nIG9wcw0KIGlzIHRoZSBsYXN0IG9wcyBpbiBkbV90aGluX2lu
aXQuDQoNClNpZ25lZC1vZmYtYnk6IG1vbnR5IDxtb250eV9wYXZlbEBzaW5hLmNvbT4NCi0tLQ0K
IGRyaXZlcnMvbWQvZG0tdGhpbi5jIHwgICAyMiArKysrKysrKysrLS0tLS0tLS0tLS0tDQogMSBm
aWxlcyBjaGFuZ2VkLCAxMCBpbnNlcnRpb25zKCspLCAxMiBkZWxldGlvbnMoLSkNCg0KZGlmZiAt
LWdpdCBhL2RyaXZlcnMvbWQvZG0tdGhpbi5jIGIvZHJpdmVycy9tZC9kbS10aGluLmMNCmluZGV4
IDg5ZTVkZmYuLmY5MWQ3NzEgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL21kL2RtLXRoaW4uYw0KKysr
IGIvZHJpdmVycy9tZC9kbS10aGluLmMNCkBAIC00MzU1LDMwICs0MzU1LDI4IEBAIHN0YXRpYyB2
b2lkIHRoaW5faW9faGludHMoc3RydWN0IGRtX3RhcmdldCAqdGksIHN0cnVjdCBxdWV1ZV9saW1p
dHMgKmxpbWl0cykNCiANCiBzdGF0aWMgaW50IF9faW5pdCBkbV90aGluX2luaXQodm9pZCkNCiB7
DQotIGludCByOw0KKyBpbnQgciA9IC1FTk9NRU07DQogDQogIHBvb2xfdGFibGVfaW5pdCgpOw0K
IA0KKyBfbmV3X21hcHBpbmdfY2FjaGUgPSBLTUVNX0NBQ0hFKGRtX3RoaW5fbmV3X21hcHBpbmcs
IDApOw0KKyBpZiAoIV9uZXdfbWFwcGluZ19jYWNoZSkNCisgcmV0dXJuIHI7DQorDQogIHIgPSBk
bV9yZWdpc3Rlcl90YXJnZXQoJnRoaW5fdGFyZ2V0KTsNCiAgaWYgKHIpDQotIHJldHVybiByOw0K
KyBnb3RvIGJhZF9uZXdfbWFwcGluZ19jYWNoZTsNCiANCiAgciA9IGRtX3JlZ2lzdGVyX3Rhcmdl
dCgmcG9vbF90YXJnZXQpOw0KICBpZiAocikNCi0gZ290byBiYWRfcG9vbF90YXJnZXQ7DQotDQot
IHIgPSAtRU5PTUVNOw0KLQ0KLSBfbmV3X21hcHBpbmdfY2FjaGUgPSBLTUVNX0NBQ0hFKGRtX3Ro
aW5fbmV3X21hcHBpbmcsIDApOw0KLSBpZiAoIV9uZXdfbWFwcGluZ19jYWNoZSkNCi0gZ290byBi
YWRfbmV3X21hcHBpbmdfY2FjaGU7DQorIGdvdG8gYmFkX3RoaW5fdGFyZ2V0Ow0KIA0KICByZXR1
cm4gMDsNCiANCi1iYWRfbmV3X21hcHBpbmdfY2FjaGU6DQotIGRtX3VucmVnaXN0ZXJfdGFyZ2V0
KCZwb29sX3RhcmdldCk7DQotYmFkX3Bvb2xfdGFyZ2V0Og0KK2JhZF90aGluX3RhcmdldDoNCiAg
ZG1fdW5yZWdpc3Rlcl90YXJnZXQoJnRoaW5fdGFyZ2V0KTsNCitiYWRfbmV3X21hcHBpbmdfY2Fj
aGU6DQorIGttZW1fY2FjaGVfZGVzdHJveShfbmV3X21hcHBpbmdfY2FjaGUpOw0KIA0KICByZXR1
cm4gcjsNCiB9DQotLSANCjEuNy4xDQo=

------=_001_NextPart652568046867_=----
Content-Type: text/html;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

<html><head><meta http-equiv=3D"content-type" content=3D"text/html; charse=
t=3Dus-ascii"><style>body { line-height: 1.5; }body { font-size: 10.5pt; f=
ont-family: 'Segoe UI'; color: rgb(0, 0, 0); line-height: 1.5; }</style></=
head><body>=0A<div><span></span><span style=3D"font-family: &quot;" segoe=
=3D"" ui'";=3D"" font-size:=3D"" 14px;=3D"" color:=3D"" rgb(0,=3D"" 0,=3D"=
" 0);=3D"" background-color:=3D"" rgba(0,=3D"" font-weight:=3D"" normal;=
=3D"" font-style:=3D"" normal;text-decoration:=3D"" none;'=3D"">We&nbsp;go=
t&nbsp;a&nbsp;NULL&nbsp;pointer&nbsp;exception&nbsp;when&nbsp;testing&nbsp=
;the&nbsp;two&nbsp;concurrent<br>&nbsp;"vgchange&nbsp;-ay&nbsp;-K&nbsp;&lt=
;vg&nbsp;name&gt;".</span></div><div><span style=3D"font-family: &quot;" s=
egoe=3D"" ui'";=3D"" font-size:=3D"" 14px;=3D"" color:=3D"" rgb(0,=3D"" 0,=
=3D"" 0);=3D"" background-color:=3D"" rgba(0,=3D"" font-weight:=3D"" norma=
l;=3D"" font-style:=3D"" normal;text-decoration:=3D"" none;'=3D"">panic&nb=
sp;call&nbsp;trace:<br>&nbsp;PID:&nbsp;25992&nbsp;TASK:&nbsp;ffff883cd7d23=
500&nbsp;CPU:&nbsp;4&nbsp;COMMAND:&nbsp;"vgchange"<br>&nbsp;&nbsp;#0&nbsp;=
[ffff883cd743d600]&nbsp;machine_kexec&nbsp;at&nbsp;ffffffff81038fa9<br>&nb=
sp;&nbsp;0000001&nbsp;[ffff883cd743d660]&nbsp;crash_kexec&nbsp;at&nbsp;fff=
fffff810c5992<br>&nbsp;&nbsp;0000002&nbsp;[ffff883cd743d730]&nbsp;oops_end=
&nbsp;at&nbsp;ffffffff81515c90<br>&nbsp;&nbsp;0000003&nbsp;[ffff883cd743d7=
60]&nbsp;no_context&nbsp;at&nbsp;ffffffff81049f1b<br>&nbsp;&nbsp;0000004&n=
bsp;[ffff883cd743d7b0]&nbsp;__bad_area_nosemaphore&nbsp;at&nbsp;ffffffff81=
04a1a5<br>&nbsp;&nbsp;0000005&nbsp;[ffff883cd743d800]&nbsp;bad_area&nbsp;a=
t&nbsp;ffffffff8104a2ce<br>&nbsp;&nbsp;0000006&nbsp;[ffff883cd743d830]&nbs=
p;__do_page_fault&nbsp;at&nbsp;ffffffff8104aa6f<br>&nbsp;&nbsp;0000007&nbs=
p;[ffff883cd743d950]&nbsp;do_page_fault&nbsp;at&nbsp;ffffffff81517bae<br>&=
nbsp;&nbsp;0000008&nbsp;[ffff883cd743d980]&nbsp;page_fault&nbsp;at&nbsp;ff=
ffffff81514f95<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[exception&nbsp;RIP:&nbsp;=
kmem_cache_alloc+108]<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;RIP:&nbsp;ffffffff8=
116ef3c&nbsp;RSP:&nbsp;ffff883cd743da38&nbsp;RFLAGS:&nbsp;00010046<br>&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;RAX:&nbsp;0000000000000004&nbsp;RBX:&nbsp;ffffff=
ff81121b90&nbsp;RCX:&nbsp;ffff881bf1e78cc0<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;RDX:&nbsp;0000000000000000&nbsp;RSI:&nbsp;00000000000000d0&nbsp;RDI:&nbs=
p;0000000000000000<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;RBP:&nbsp;ffff883cd743=
da68&nbsp;R8:&nbsp;ffff881bf1a4eb00&nbsp;R9:&nbsp;0000000080042000<br>&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;R10:&nbsp;0000000000002000&nbsp;R11:&nbsp;000000=
0000000000&nbsp;R12:&nbsp;00000000000000d0<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;R13:&nbsp;0000000000000000&nbsp;R14:&nbsp;00000000000000d0&nbsp;R15:&nbs=
p;0000000000000246<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;ORIG_RAX:&nbsp;fffffff=
fffffffff&nbsp;CS:&nbsp;0010&nbsp;SS:&nbsp;0018<br>&nbsp;&nbsp;0000009&nbs=
p;[ffff883cd743da70]&nbsp;mempool_alloc_slab&nbsp;at&nbsp;ffffffff81121ba5=
<br>&nbsp;0000010&nbsp;[ffff883cd743da80]&nbsp;mempool_create_node&nbsp;at=
&nbsp;ffffffff81122083<br>&nbsp;0000011&nbsp;[ffff883cd743dad0]&nbsp;mempo=
ol_create&nbsp;at&nbsp;ffffffff811220f4<br>&nbsp;0000012&nbsp;[ffff883cd74=
3dae0]&nbsp;pool_ctr&nbsp;at&nbsp;ffffffffa08de049&nbsp;[dm_thin_pool]<br>=
&nbsp;0000013&nbsp;[ffff883cd743dbd0]&nbsp;dm_table_add_target&nbsp;at&nbs=
p;ffffffffa0005f2f&nbsp;[dm_mod]<br>&nbsp;0000014&nbsp;[ffff883cd743dc30]&=
nbsp;table_load&nbsp;at&nbsp;ffffffffa0008ba9&nbsp;[dm_mod]<br>&nbsp;00000=
15&nbsp;[ffff883cd743dc90]&nbsp;ctl_ioctl&nbsp;at&nbsp;ffffffffa0009dc4&nb=
sp;[dm_mod]<br>&nbsp;this&nbsp;bug's&nbsp;scence&nbsp;is&nbsp;as&nbsp;foll=
ows:<br>&nbsp;process&nbsp;A(vgchange&nbsp;-ay&nbsp;-K):<br>&nbsp;<span st=
yle=3D"white-space: pre;">	</span>a.&nbsp;send&nbsp;DM_LIST_VERSIONS_CMD&n=
bsp;ioctl;<br>&nbsp;<span style=3D"white-space: pre;">	</span>b.&nbsp;pool=
_target&nbsp;not&nbsp;registered;<br>&nbsp;<span style=3D"white-space: pre=
;">	</span>c.&nbsp;modprobe&nbsp;dm_thin_pool&nbsp;and&nbsp;wait&nbsp;unti=
l&nbsp;end.<br>&nbsp;process&nbsp;B(vgchange&nbsp;-ay&nbsp;-K):<br>&nbsp;<=
span style=3D"white-space: pre;">	</span>a.&nbsp;send&nbsp;DM_LIST_VERSION=
S_CMD&nbsp;ioctl;<br>&nbsp;<span style=3D"white-space: pre;">	</span>b.&nb=
sp;pool_target&nbsp;registered;<br>&nbsp;<span style=3D"white-space: pre;"=
>	</span>c.&nbsp;table_load-&gt;dm_table_add_target-&gt;pool_ctr;<br>&nbsp=
;<span style=3D"white-space: pre;">	</span>d.&nbsp;_new_mapping_cache&nbsp=
;is&nbsp;NULL&nbsp;and&nbsp;panic.<br>&nbsp;note:<br>&nbsp;<span style=3D"=
white-space: pre;">	</span>1.&nbsp;process&nbsp;A&nbsp;and&nbsp;process&nb=
sp;B&nbsp;are&nbsp;two&nbsp;concurrent&nbsp;processes.<br>&nbsp;<span styl=
e=3D"white-space: pre;">	</span>2.&nbsp;pool_target&nbsp;can&nbsp;be&nbsp;=
detected&nbsp;by&nbsp;process&nbsp;B&nbsp;but<br>&nbsp;<span style=3D"whit=
e-space: pre;">	</span>_new_mapping_cache&nbsp;initialization&nbsp;has&nbs=
p;not&nbsp;ended.<br>&nbsp;All&nbsp;that&nbsp;we&nbsp;need&nbsp;do&nbsp;is=
&nbsp;to&nbsp;ensure&nbsp;pool_target&nbsp;registering&nbsp;ops<br>&nbsp;i=
s&nbsp;the&nbsp;last&nbsp;ops&nbsp;in&nbsp;dm_thin_init.<br><br>Signed-off=
-by:&nbsp;monty&nbsp;&lt;monty_pavel@sina.com&gt;<br>---<br>&nbsp;drivers/=
md/dm-thin.c&nbsp;|&nbsp;&nbsp;&nbsp;22&nbsp;++++++++++------------<br>&nb=
sp;1&nbsp;files&nbsp;changed,&nbsp;10&nbsp;insertions(+),&nbsp;12&nbsp;del=
etions(-)<br><br>diff&nbsp;--git&nbsp;a/drivers/md/dm-thin.c&nbsp;b/driver=
s/md/dm-thin.c<br>index&nbsp;89e5dff..f91d771&nbsp;100644<br>---&nbsp;a/dr=
ivers/md/dm-thin.c<br>+++&nbsp;b/drivers/md/dm-thin.c<br>@@&nbsp;-4355,30&=
nbsp;+4355,28&nbsp;@@&nbsp;static&nbsp;void&nbsp;thin_io_hints(struct&nbsp=
;dm_target&nbsp;*ti,&nbsp;struct&nbsp;queue_limits&nbsp;*limits)<br>&nbsp;=
<br>&nbsp;static&nbsp;int&nbsp;__init&nbsp;dm_thin_init(void)<br>&nbsp;{<b=
r>-<span style=3D"white-space: pre;">	</span>int&nbsp;r;<br>+<span style=
=3D"white-space: pre;">	</span>int&nbsp;r&nbsp;=3D&nbsp;-ENOMEM;<br>&nbsp;=
<br>&nbsp;<span style=3D"white-space: pre;">	</span>pool_table_init();<br>=
&nbsp;<br>+<span style=3D"white-space: pre;">	</span>_new_mapping_cache&nb=
sp;=3D&nbsp;KMEM_CACHE(dm_thin_new_mapping,&nbsp;0);<br>+<span style=3D"wh=
ite-space: pre;">	</span>if&nbsp;(!_new_mapping_cache)<br>+<span style=3D"=
white-space: pre;">	</span><span style=3D"white-space: pre;">	</span>retur=
n&nbsp;r;<br>+<br>&nbsp;<span style=3D"white-space: pre;">	</span>r&nbsp;=
=3D&nbsp;dm_register_target(&amp;thin_target);<br>&nbsp;<span style=3D"whi=
te-space: pre;">	</span>if&nbsp;(r)<br>-<span style=3D"white-space: pre;">=
	</span><span style=3D"white-space: pre;">	</span>return&nbsp;r;<br>+<span=
 style=3D"white-space: pre;">	</span><span style=3D"white-space: pre;">	</=
span>goto&nbsp;bad_new_mapping_cache;<br>&nbsp;<br>&nbsp;<span style=3D"wh=
ite-space: pre;">	</span>r&nbsp;=3D&nbsp;dm_register_target(&amp;pool_targ=
et);<br>&nbsp;<span style=3D"white-space: pre;">	</span>if&nbsp;(r)<br>-<s=
pan style=3D"white-space: pre;">	</span><span style=3D"white-space: pre;">=
	</span>goto&nbsp;bad_pool_target;<br>-<br>-<span style=3D"white-space: pr=
e;">	</span>r&nbsp;=3D&nbsp;-ENOMEM;<br>-<br>-<span style=3D"white-space: =
pre;">	</span>_new_mapping_cache&nbsp;=3D&nbsp;KMEM_CACHE(dm_thin_new_mapp=
ing,&nbsp;0);<br>-<span style=3D"white-space: pre;">	</span>if&nbsp;(!_new=
_mapping_cache)<br>-<span style=3D"white-space: pre;">	</span><span style=
=3D"white-space: pre;">	</span>goto&nbsp;bad_new_mapping_cache;<br>+<span =
style=3D"white-space: pre;">	</span><span style=3D"white-space: pre;">	</s=
pan>goto&nbsp;bad_thin_target;<br>&nbsp;<br>&nbsp;<span style=3D"white-spa=
ce: pre;">	</span>return&nbsp;0;<br>&nbsp;<br>-bad_new_mapping_cache:<br>-=
<span style=3D"white-space: pre;">	</span>dm_unregister_target(&amp;pool_t=
arget);<br>-bad_pool_target:<br>+bad_thin_target:<br>&nbsp;<span style=3D"=
white-space: pre;">	</span>dm_unregister_target(&amp;thin_target);<br>+bad=
_new_mapping_cache:<br>+<span style=3D"white-space: pre;">	</span>kmem_cac=
he_destroy(_new_mapping_cache);<br>&nbsp;<br>&nbsp;<span style=3D"white-sp=
ace: pre;">	</span>return&nbsp;r;<br>&nbsp;}<br>--&nbsp;<br>1.7.1</span></=
div>=0A</body></html>
------=_001_NextPart652568046867_=------



--===============8760186108281885390==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============8760186108281885390==--
