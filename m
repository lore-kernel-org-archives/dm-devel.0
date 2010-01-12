From: jjaing <jjaing@163.com>
Subject: dmsetup snapshot merge problem
Date: Tue, 12 Jan 2010 11:12:26 +0800 (CST)
Message-ID: <10902610.542611263265946202.JavaMail.coremail@bj163app61.163.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============3006960268499559085=="
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

--===============3006960268499559085==
Content-Type: multipart/alternative;
	boundary="----=_Part_140344_30224992.1263265946202"

------=_Part_140344_30224992.1263265946202
Content-Type: text/plain; charset=gbk
Content-Transfer-Encoding: base64

SGkgQWxso6wKICAgICAiZWNobyAwICQoYmxvY2tkZXYgLS1nZXRzaXplIC9kZXYvbG9vcDApIHNu
YXBzaG90IC9kZXYvbG9vcDAgL2Rldi9sb29wMSBuIDY0IHwgZG1zZXR1cCBjcmVhdGUgdGVzdGNv
dyIKCiAgICAgIEkgdXNlIHRoZSBhYm92ZSBjb21tYW5kIHRvIGNyZWF0ZSBhIHRlc3Rjb3csIEkg
ZG9udCBmaW5kIGhvdyB0byB1c2Ugc25hcHNob3Qgb24gZG1zZXR1cCwgc28gaW4gbXkgdW5kZXJz
dGFuZGluZywgdGVzdGNvdyB3aWxsIGJlIHNldHVwIGFzIC9kZXYvbG9vcDAgZm9yIHJlYWRpbmcg
YW5kIC9kZXYvbG9vcDEgZm9yIHdyaXRpbmcuIGRvZXMgaXQgY29ycmVjdD8gIGlzIHRoZXJlIGFu
eSBtYW51YWwgb24gaG93IHRvIHVzZSBzbmFwc2hvdD8KICAgICBhbmQgY291bGQgYW55b25lIHRl
bGwgbWUgLCBob3cgdG8gbWVyZ2UgdGhpcyB0d28gZGV2aWNlJ3MgY29udGVudHMgYWZ0ZXIgSSBt
YWRlIHNvbWUgd3JpdGluZyBvbiB0ZXN0Y293PwogICAgIFRoYW5rcyEKCiAgICAgICAgCg==
------=_Part_140344_30224992.1263265946202
Content-Type: text/html; charset=gbk
Content-Transfer-Encoding: base64

SGkgQWxso6w8YnI+Jm5ic3A7Jm5ic3A7Jm5ic3A7Jm5ic3A7ICJlY2hvIDAgJChibG9ja2RldiAt
LWdldHNpemUgL2Rldi9sb29wMCkgc25hcHNob3QgL2Rldi9sb29wMCAvZGV2L2xvb3AxIG4gNjQg
fCBkbXNldHVwIGNyZWF0ZSB0ZXN0Y293Ijxicj48YnI+Jm5ic3A7Jm5ic3A7Jm5ic3A7Jm5ic3A7
Jm5ic3A7IEkgdXNlIHRoZSBhYm92ZSBjb21tYW5kIHRvIGNyZWF0ZSBhIHRlc3Rjb3csIEkgZG9u
dCBmaW5kIGhvdyB0byB1c2Ugc25hcHNob3Qgb24gZG1zZXR1cCwgc28gaW4gbXkgdW5kZXJzdGFu
ZGluZywgdGVzdGNvdyB3aWxsIGJlIHNldHVwIGFzIC9kZXYvbG9vcDAgZm9yIHJlYWRpbmcgYW5k
ICAvZGV2L2xvb3AxIGZvciB3cml0aW5nLiBkb2VzIGl0IGNvcnJlY3Q/Jm5ic3A7IGlzIHRoZXJl
IGFueSBtYW51YWwgb24gaG93IHRvIHVzZSBzbmFwc2hvdD88YnI+Jm5ic3A7Jm5ic3A7Jm5ic3A7
Jm5ic3A7IGFuZCBjb3VsZCBhbnlvbmUgdGVsbCBtZSAsIGhvdyB0byBtZXJnZSB0aGlzIHR3byBk
ZXZpY2UncyBjb250ZW50cyBhZnRlciBJIG1hZGUgc29tZSB3cml0aW5nIG9uICB0ZXN0Y293Pzxi
cj4mbmJzcDsmbmJzcDsmbmJzcDsmbmJzcDsgVGhhbmtzITxicj48YnI+Jm5ic3A7Jm5ic3A7Jm5i
c3A7Jm5ic3A7Jm5ic3A7Jm5ic3A7Jm5ic3A7IDxicj48YnI+PGJyPjxzcGFuIHRpdGxlPSJuZXRl
YXNlZm9vdGVyIi8+PC9zcGFuPg==
------=_Part_140344_30224992.1263265946202--


--===============3006960268499559085==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============3006960268499559085==--
