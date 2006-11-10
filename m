From: Edward Goggin <egoggin@emc.com>
Subject: patch to discovery.c to still get path priority for
	paths with path state of PATH_DOWN
Date: Fri, 10 Nov 2006 18:01:25 -0500
Message-ID: <6CCEAEDF4D06984A83F427424F47D6E4013D1535@CORPUSMX40A.corp.emc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============2140881416=="
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
Content-Description: discovery.c.diff
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: christophe.varoqui@free.fr
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

--===============2140881416==
Content-class: urn:content-classes:message
Content-Type: application/octet-stream;
	name="discovery.c.diff"
Content-Transfer-Encoding: base64
Content-Description: discovery.c.diff
Content-Disposition: attachment;
	filename="discovery.c.diff"

ZGlmZiAtLWdpdCBhL2xpYm11bHRpcGF0aC9kaXNjb3ZlcnkuYyBiL2xpYm11bHRpcGF0aC9kaXNj
b3ZlcnkuYw0KaW5kZXggZWZjMjAxNi4uMTVmZTg5YiAxMDA2NDQNCi0tLSBhL2xpYm11bHRpcGF0
aC9kaXNjb3ZlcnkuYw0KKysrIGIvbGlibXVsdGlwYXRoL2Rpc2NvdmVyeS5jDQpAQCAtNzAxLDcg
KzcwMSwxNCBAQCBwYXRoaW5mbyAoc3RydWN0IHBhdGggKnBwLCB2ZWN0b3IgaHd0YWJsDQogCWlm
IChtYXNrICYgRElfQ0hFQ0tFUiAmJiBnZXRfc3RhdGUocHApKQ0KIAkJZ290byBibGFuazsNCiAJ
DQotCWlmIChtYXNrICYgRElfUFJJTyAmJiBwcC0+c3RhdGUgIT0gUEFUSF9ET1dOKQ0KKw0KKwkv
Kg0KKwkgKiBQYXRoIHN0YXRlIG9mIFBBVEhfRE9XTiBkb2VzIG5vdCBuZWNlc3NhcmlseSBwcmV2
ZW50DQorCSAqIHBhdGggcHJpb3JpdHkgY2FsbG91dCAob3IgZ2V0dWlkIGNhbGxvdW90KSBmcm9t
DQorCSAqIHN1Y2NlZWRpbmcgc2luY2UgdGhlIHBhdGggbWF5IGJlIGJlaW5nIGNvbnNpZGVyZWQN
CisJICogZmFpbGVkIGZvciByZWFzb25zIG90aGVyIHRoYW4gdHJhbnNwb3J0IGNvbm5lY3Rpdml0
eS4NCisJICovDQorCWlmIChtYXNrICYgRElfUFJJTyAvKiYmIHBwLT5zdGF0ZSAhPSBQQVRIX0RP
V04qLykNCiAJCWdldF9wcmlvKHBwKTsNCiANCiAJaWYgKG1hc2sgJiBESV9XV0lEICYmICFzdHJs
ZW4ocHAtPnd3aWQpKQ==


--===============2140881416==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============2140881416==--
