From: Magnus Hagebris <magnus@mirapoint.com>
Subject: [multipath] SNMP traps on path failures?
Date: Thu, 28 Jun 2007 09:38:19 -0700
Message-ID: <1183048699.21973.17.camel@magnus.mirapoint.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
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

So I can look at the log files for path failures, maybe even use
logsurfer to parse and send a snmp trap. But wouldn't there be nice to
have som builtin hook to use instead?

What's the policy for path failure notifications? Are we simply suppose
to parse the log files? Are there any enhancements in this field? Or am
simply missing something very trivial?

Using RHEL4u5 if that matters...

Best regards,
 Magnus Hagebris
