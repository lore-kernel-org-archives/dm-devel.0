From: "Christopher C. Weis" <ccweis@gmail.com>
Subject: multipath configuration questions
Date: Tue, 02 Aug 2005 09:37:14 -0500
Message-ID: <42EF851A.20108@gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
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

Hello.  I don't know if this is the proper place to post this, so please
point me to the correct list if it isn't.

I have a multipath SAN environment with storage controllers that are
active/active.  However, the controllers are not active/active at the
LUN-level without a performance penalty, meaning if two servers want to
see the same LUN (as in a clustered filesystem environment), they both
need to be using the same controller.  I'm trying to figure out a way to
statically "order" the paths so that I can copy a config to all of the
nodes using the CFS.

From what I've read, in a single-server environment with controllers
such as the ones I'm dealing with, the path_grouping_policy should be
set to "group_by_serial", which should work fine, but in a clustered
environment, I need to be sure that the path ordering is the same.

Are there any path_selectors, other than round-robin, that might
accomplish this?  Any other ideas?

Thanks.  I appreciate any information that can be offered.

~Chris
