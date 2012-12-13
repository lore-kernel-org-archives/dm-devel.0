From: Joe Thornber <ejt@redhat.com>
Subject: Another cache target
Date: Thu, 13 Dec 2012 20:19:08 +0000
Message-ID: <1355429956-22785-1-git-send-email-ejt@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
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

Here's a cache target that Heinz Mauelshagen, Mike Snitzer and I
have been working on.

It's also available in the thin-dev branch of my git tree:

git@github.com:jthornber/linux-2.6.git

The main features are a plug-in architecture for policies which decide
what data gets cached, and reuse of the metadata library from the thin
provisioning target.

These patches apply on top of the dm patches that agk has got queued
for 3.8.

If anyone has the time to try it out I'd love to hear how you get on.
