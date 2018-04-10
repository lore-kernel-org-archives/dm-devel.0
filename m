From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: Re: [PATCH RFC] multipath-tools: create LICENSES dir
 with the text of all used licences
Date: Tue, 10 Apr 2018 17:42:18 +0200
Message-ID: <c1d4c853-13ff-0ecb-e502-8b4ce7c21f91@gmail.com>
References: <20180409165104.6936-1-xose.vazquez@gmail.com>
	<1523345116.3525.70.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1523345116.3525.70.camel@suse.com>
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
To: Martin Wilck <mwilck@suse.com>, Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 04/10/2018 09:25 AM, Martin Wilck wrote:
> On Mon, 2018-04-09 at 18:51 +0200, Xose Vazquez Perez wrote:
>> Move COPYING -> LICENSES/GPL-2.0
>> Move COPYING.LESSER -> LICENSES/LGPL-2.0
>>
>> Add GPL-3.0 and LGPL-2.1 to the LICENSES dir.
>> Source directly from:
>> https://www.gnu.org/licenses/gpl-3.0.txt
>> https://www.gnu.org/licenses/old-licenses/lgpl-2.1.txt
>>
>> Cc: Martin Wilck <mwilck@suse.com>
>> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
>> Cc: device-mapper development <dm-devel@redhat.com>
>> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
>> ---
> 
> I like this.
> Acked-by: Martin Wilck <mwilck@suse.com>
> 
> I  suggest to add my posting from yesterday ("multipath-tools 0.7.6
> fossology license assessment") as "README.licenses".
> With these changes, we'd be in a fine state for the time being.
> 
> Actual license changes can be considered for the long term, but don't
> need to be - the current situation is complex but not actually
> problematic. SPDX tags can be added to source files by and by, as we
> see fit.

In the meantime, this patch should clarify the default license:

From c10b33cd2385f3726a0a47e5356b7bec20b10963 Mon Sep 17 00:00:00 2001
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Date: Tue, 10 Apr 2018 17:34:44 +0200
Subject: [PATCH] multipath-tools: link LICENSES/LGPL-2.0 to COPYING

Default licence is LGPL-2.0

Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 COPYING | 1 +
 1 file changed, 1 insertion(+)
 create mode 120000 COPYING

diff --git a/COPYING b/COPYING
new file mode 120000
index 0000000..0c0462d
--- /dev/null
+++ b/COPYING
@@ -0,0 +1 @@
+LICENSES/LGPL-2.0
\ No newline at end of file
-- 
2.17.0
