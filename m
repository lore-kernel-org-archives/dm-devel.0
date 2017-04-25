From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [BUG] multipath-tools: redefined devices, with regex,
 in multipath.conf appear twice
Date: Wed, 26 Apr 2017 00:18:27 +0200
Message-ID: <bc675810-1f04-6230-767b-3f147a5e3d0a@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------046796C5412C57FCB13DDAED"
Return-path: <dm-devel-bounces@redhat.com>
Content-Language: en-GB
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

This is a multi-part message in MIME format.
--------------046796C5412C57FCB13DDAED
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit

Hi,

Redefined devices, with a regex in product/vendor, in multipath.conf
appear twice in multipath config.


Place attached multipath.conf in /etc, and run multipath -t.
For NETAPP/LUN it works OK. Only one is displayed.

But "^DGC"/"^(RAID|DISK|VRAID)" appears twice.



Thank you.


--------------046796C5412C57FCB13DDAED
Content-Type: text/plain; charset=UTF-8;
 name="multipath.conf"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="multipath.conf"

ZGV2aWNlcyB7CglkZXZpY2UgewoJCXZlbmRvciAiXkRHQyIKCQlwcm9kdWN0ICJeKFJBSUR8
RElTS3xWUkFJRCkiCgkJcHJvZHVjdF9ibGFja2xpc3QgIkxVTloiCgkJcGF0aF9ncm91cGlu
Z19wb2xpY3kgImdyb3VwX2J5X3ByaW8iCgkJcGF0aF9jaGVja2VyICJ0dXIiCgkJaGFyZHdh
cmVfaGFuZGxlciAiMSBlbWMiCgkJcHJpbyAiZW1jIgoJCWZhaWxiYWNrICJpbW1lZGlhdGUi
CgkJbm9fcGF0aF9yZXRyeSA2MAoJfQoJZGV2aWNlIHsKCQl2ZW5kb3IgIk5FVEFQUCIKCQlw
cm9kdWN0ICJMVU4iCgkJcGF0aF9ncm91cGluZ19wb2xpY3kgImdyb3VwX2J5X3ByaW8iCgkJ
ZmVhdHVyZXMgIjIgcGdfaW5pdF9yZXRyaWVzIDUwIgoJCXByaW8gImFsdWEiCgkJZmFpbGJh
Y2sgImltbWVkaWF0ZSIKCQlub19wYXRoX3JldHJ5ICJxdWV1ZSIKCQlmbHVzaF9vbl9sYXN0
X2RlbCAieWVzIgoJCWRldl9sb3NzX3RtbyAiaW5maW5pdHkiCgl9Cn0K
--------------046796C5412C57FCB13DDAED
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--------------046796C5412C57FCB13DDAED--
