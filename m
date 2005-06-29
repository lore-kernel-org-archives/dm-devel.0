From: "Zhao Qian" <zhaoqian@aaastor.com>
Subject: bio's bi_size bug also be founded at dm-stripe.c and
	dm-snap.c
Date: Wed, 29 Jun 2005 18:02:56 +0800
Message-ID: <006f01c57c91$bc1a75c0$1f000064@polaris>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1948156087=="
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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

This is a multi-part message in MIME format.

--===============1948156087==
Content-Type: multipart/alternative;
	boundary="----=_NextPart_000_006C_01C57CD4.C74C6230"

This is a multi-part message in MIME format.

------=_NextPart_000_006C_01C57CD4.C74C6230
Content-Type: text/plain;
	charset="gb2312"
Content-Transfer-Encoding: base64

QXMgaSBoYWQgd3JpdHRlbiBoZXJlIGJlZm9yZSwgc29tZXRpbWVzIGJpbyB3aGljaCBkaXNwYXRj
aGVkIHRvIHRoZSBkbSdzIHRhcmdldCwgaXQncyBiaV9zaXplIGNvdWxkIGV4Y2VlZA0KcmVnaW9u
IHNpemUgaW4gZG0tbWlycm9yLmMsIGkgYWxzbyBmb3VuZCBzaW1pbGFyIHByb2JsZW0gaW4gZG0t
c3RyaXBlLmMgYW5kIGRtLXNuYXAuYyAsIGluIHN1Y2ggc2l0dWF0aW9uLA0KYmlvJ3MgYmlfc2l6
ZSBjb3VsZCBleGNlZWQgc3RyaXAgdGFyZ2V0J3MgY2h1bmsgc2l6ZSBhbmQgc25hcCB0YXJnZXQn
cyBjaHVuayBzaXplLCBidXQgaW4gY3VycmVudCBjb2RlLCB3ZQ0KbmV2ZXIgY2FyZSBhYm91dCB0
aGlzLiBzbyBpbiBzdHJpcCB0YXJnZXQgd2UgY291bGQgcmVhZC93cml0ZSBiYWQgcG9zaXRpb24g
YWZ0ZXIgc3RyaXBlX21hcCgpIGZ1bmN0aW9uLA0KYW5kIGNhdXNlIHNhbWUgZWZmZWN0IGluIGRt
LXNuYXAuYy4NCkkgdGhpbmsgc3VjaCBidWdzIGFyZSB2ZXJ5IGRhbmdlcm91cyB0aGVuIGtlcm5l
bCBwYW5pYyBvciBjcmFjc2ggYmVjYXN1ZSBpdCBtYXkgZGVzdHJveSB5b3VyIGRhdGEgDQppbiBz
aWxlbmNlLiB3ZSdkIGJldHRlciB0byBhbm5vbnVjZSBvdXIgbGludXggdXNlcnMgZG9uJ3QgdXNl
IHRodXMgZG0tdGFyZ2V0cyBiZWZvcmUgd2UgY29ycmVjdCBpdC4NCg0KU2luY2VyZWx5LA0KICAg
ICAgICAgICAgICAgIFpoYW8gUWlhbiA8emhhb3FpYW5AYWFhc3Rvci5jb20+DQoNCg==

------=_NextPart_000_006C_01C57CD4.C74C6230
Content-Type: text/html;
	charset="gb2312"
Content-Transfer-Encoding: base64

PCFET0NUWVBFIEhUTUwgUFVCTElDICItLy9XM0MvL0RURCBIVE1MIDQuMCBUcmFuc2l0aW9uYWwv
L0VOIj4NCjxIVE1MPjxIRUFEPg0KPE1FVEEgaHR0cC1lcXVpdj1Db250ZW50LVR5cGUgY29udGVu
dD0idGV4dC9odG1sOyBjaGFyc2V0PWdiMjMxMiI+DQo8TUVUQSBjb250ZW50PSJNU0hUTUwgNi4w
MC4yOTAwLjI2NjgiIG5hbWU9R0VORVJBVE9SPg0KPFNUWUxFPjwvU1RZTEU+DQo8L0hFQUQ+DQo8
Qk9EWSBiZ0NvbG9yPSNmZmZmZmY+DQo8RElWPjxGT05UIHNpemU9Mj5BcyBpIGhhZCB3cml0dGVu
IGhlcmUgYmVmb3JlLCBzb21ldGltZXMgYmlvIHdoaWNoIGRpc3BhdGNoZWQgDQp0byB0aGUgZG0n
cyB0YXJnZXQsIGl0J3MgYmlfc2l6ZSBjb3VsZCBleGNlZWQ8L0ZPTlQ+PC9ESVY+DQo8RElWPjxG
T05UIHNpemU9Mj5yZWdpb24gc2l6ZSBpbiBkbS1taXJyb3IuYywgaSBhbHNvIGZvdW5kIHNpbWls
YXIgcHJvYmxlbSBpbiANCmRtLXN0cmlwZS5jIGFuZCBkbS1zbmFwLmMgLCBpbiBzdWNoIHNpdHVh
dGlvbiw8L0ZPTlQ+PC9ESVY+DQo8RElWPjxGT05UIHNpemU9Mj5iaW8ncyBiaV9zaXplIGNvdWxk
IGV4Y2VlZCBzdHJpcCB0YXJnZXQncyBjaHVuayBzaXplIGFuZCBzbmFwIA0KdGFyZ2V0J3MgY2h1
bmsgc2l6ZSwgYnV0IGluIGN1cnJlbnQgY29kZSwgd2U8L0ZPTlQ+PC9ESVY+DQo8RElWPjxGT05U
IHNpemU9Mj5uZXZlciBjYXJlIGFib3V0IHRoaXMuIHNvIGluIHN0cmlwIHRhcmdldCB3ZSBjb3Vs
ZCByZWFkL3dyaXRlIA0KYmFkIHBvc2l0aW9uIGFmdGVyIDxGT05UIHNpemU9Mz5zdHJpcGVfbWFw
KCkgZnVuY3Rpb24sPC9GT05UPjwvRk9OVD48L0RJVj4NCjxESVY+YW5kIGNhdXNlIHNhbWUgZWZm
ZWN0IGluIGRtLXNuYXAuYy48L0RJVj4NCjxESVY+SSB0aGluayZuYnNwO3N1Y2ggYnVncyZuYnNw
O2FyZSZuYnNwO3ZlcnkgZGFuZ2Vyb3VzJm5ic3A7dGhlbiBrZXJuZWwgcGFuaWMgDQpvciBjcmFj
c2ggYmVjYXN1ZSBpdCBtYXkgZGVzdHJveSB5b3VyIGRhdGEgPC9ESVY+DQo8RElWPmluIHNpbGVu
Y2UuIHdlJ2QgYmV0dGVyIHRvIGFubm9udWNlIG91ciBsaW51eCB1c2VycyBkb24ndCB1c2UmbmJz
cDt0aHVzIA0KZG0tdGFyZ2V0cyZuYnNwO2JlZm9yZSB3ZSBjb3JyZWN0IGl0LjwvRElWPg0KPERJ
Vj48Rk9OVCBzaXplPTI+PC9GT05UPiZuYnNwOzwvRElWPg0KPERJVj5TaW5jZXJlbHksPEJSPiZu
YnNwOyZuYnNwOyZuYnNwOyZuYnNwOyZuYnNwOyZuYnNwOyZuYnNwOyZuYnNwOyZuYnNwOyZuYnNw
OyZuYnNwOyZuYnNwOyZuYnNwOyZuYnNwOyZuYnNwOyANClpoYW8gUWlhbiAmbHQ7PEEgaHJlZj0i
Ij56aGFvcWlhbkBhYWFzdG9yLmNvbTwvQT4mZ3Q7PC9ESVY+DQo8RElWPjxGT05UIHNpemU9Mj48
L0ZPTlQ+Jm5ic3A7PC9ESVY+DQo8RElWPjxGT05UIHNpemU9Mj48L0ZPTlQ+Jm5ic3A7PC9ESVY+
PC9CT0RZPjwvSFRNTD4NCg==

------=_NextPart_000_006C_01C57CD4.C74C6230--



--===============1948156087==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1948156087==--
