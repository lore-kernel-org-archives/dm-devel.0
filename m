From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 5/5] multipath.conf(5): improve syntax
	documentation
Date: Thu,  8 Mar 2018 00:26:20 +0100
Message-ID: <20180307232620.15746-6-mwilck@suse.com>
References: <20180307232620.15746-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180307232620.15746-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

Describe the syntax of attribute / value pairs, comments, and quoted
strings, as well as the peculiarities of section beginnings and ends.
Also describe the newly added '""' feature.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipath/multipath.conf.5 | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index ab151e720d75..c4d0789475a3 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -67,6 +67,23 @@ recognized keywords for attributes or subsections depend on the
 section in which they occur.
 .LP
 .
+\fB<attribute>\fR and \fB<value>\fR must be on a single line.
+\fB<attribute>\fR is one of the keywords listed in this man page.
+\fB<value>\fR is either a simple word (containing no whitespace and none of the
+characters '\(dq', '#', and '!') or \fIone\fR string enclosed in double
+quotes ("..."). Outside a quoted string, text starting with '#', and '!' is
+regarded as a comment and ignored until the end of the line. Inside a quoted
+string, '#' and '!' are normal characters, and whitespace is preserved.
+To represent a double quote character inside a double quoted string, use two
+consecutive double quotes ('""'). Thus '2.5\(dq SSD' can be written as "2.5"" SSD".
+.LP
+.
+Opening braces ('{') must follow the (sub)section name on the same line. Closing
+braces ('}') that mark the end of a (sub)section must be the only non-whitespace
+character on the line. Whitespace is ignored except inside double quotes, thus
+the indentation shown in the above example is helpful for human readers but
+not mandatory.
+.LP
 .
 The following \fIsection\fP keywords are recognized:
 .TP 17
-- 
2.16.1
