From: "Brian Wong" <bwong@pillardata.com>
Subject: build issue in multipath-tools, HOL
Date: Thu, 17 Nov 2005 13:19:13 -0800
Message-ID: <35D744B011AD9A4A86B5962E85181C78027AB6C6@caex02.trans.corp>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="----_=_NextPart_001_01C5EBBC.8EE6FFF2"
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
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

This is a multi-part message in MIME format.

------_=_NextPart_001_01C5EBBC.8EE6FFF2
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

One of the recent commits introduced a build problem (undefined
PATH_WILD).

------_=_NextPart_001_01C5EBBC.8EE6FFF2
Content-Type: application/octet-stream;
	name="diff.out"
Content-Transfer-Encoding: base64
Content-Description: diff.out
Content-Disposition: attachment;
	filename="diff.out"

ZGlmZiAtLWdpdCBhL2xpYm11bHRpcGF0aC9zdHJ1Y3RzLmMgYi9saWJtdWx0aXBhdGgvc3RydWN0
cy5jCi0tLSBhL2xpYm11bHRpcGF0aC9zdHJ1Y3RzLmMKKysrIGIvbGlibXVsdGlwYXRoL3N0cnVj
dHMuYwpAQCAtMTIsNiArMTIsNyBAQAogI2luY2x1ZGUgInN0cnVjdHMuaCIKICNpbmNsdWRlICJj
b25maWcuaCIKICNpbmNsdWRlICJkZWJ1Zy5oIgorI2luY2x1ZGUgIi4uL2xpYmNoZWNrZXJzL3Bh
dGhfc3RhdGUuaCIKIAogc3RydWN0IHBhdGggKgogYWxsb2NfcGF0aCAodm9pZCkK

------_=_NextPart_001_01C5EBBC.8EE6FFF2
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


------_=_NextPart_001_01C5EBBC.8EE6FFF2--
