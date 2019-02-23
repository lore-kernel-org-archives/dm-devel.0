From: Kurt Garloff <kurt@garloff.de>
Subject: Re: bug: dmsetup fails to parse concise tables
Date: Sat, 23 Feb 2019 23:01:45 +0100
Message-ID: <424c7a6d-f0c6-e2d6-2e1a-bb9fac328046@garloff.de>
References: <0b154688-762c-b6ac-2925-4ee8a19962a2@garloff.de>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------79CD4B0217E18892FB5506D8"
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <0b154688-762c-b6ac-2925-4ee8a19962a2@garloff.de>
Content-Language: en-US
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

This is a multi-part message in MIME format.
--------------79CD4B0217E18892FB5506D8
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit

Hi,

On 23/02/2019 22:56, Kurt Garloff wrote:
> if I store device-mapper tables with dmsetup table --concise, I would
> expect that dmsetup create --concise would be able to parse the tables.
>
> dmsetup however fails this with a simple three-entry table like this one

Fixing patch is attached. The parser not never get to the third entry ...

Best,

-- 
Kurt Garloff <kurt@garloff.de>
Cologne, Germany


--------------79CD4B0217E18892FB5506D8
Content-Type: text/x-patch;
 name="dmsetup-parse-concise.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="dmsetup-parse-concise.diff"

From: Kurt Garloff <kurt@garloff.de>
Subject: Fix parsing of concise multi-entry tables.

The parser would never proceed to the third entry and restart to process
from the beginning. The patch fixes this typo.

Signed-off-by: Kurt Garloff <kurt@garloff.de>

--- LVM2.2.02.177/tools/dmsetup.c.orig	2017-12-18 21:44:35.000000000 +0100
+++ LVM2.2.02.177/tools/dmsetup.c	2019-01-10 13:22:07.909638399 +0100
@@ -369,7 +369,7 @@ static int _parse_table_lines(struct dm_
 
 	do {
 		/* Identify and terminate each line */
-		if ((next_pos = strchr(_table, '\n')))
+		if ((next_pos = strchr(pos, '\n')))
 			*next_pos++ = '\0';
 		if (!_parse_line(dmt, pos, "", ++line))
 			return_0;

--------------79CD4B0217E18892FB5506D8
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--------------79CD4B0217E18892FB5506D8--
