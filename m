From: Jonathan Brassow <jbrassow@redhat.com>
Subject: Snapshot Exception Store API patches (and other patches)
Date: Wed, 04 Mar 2009 15:52:08 -0600
Message-ID: <1236203529.28664.22.camel@hydrogen.msp.redhat.com>
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

I'm starting to pile up a crap ton of patches, and I'm guessing it is
becoming difficult to follow exactly what goes where.  So, I've created
some "bundles" in patchwork to help keep things straight.

The first bundle can be found at
http://patchwork.kernel.org/bundle/jbrassow/Exception%20Store%20API%
20group1/  It represents the first stage of changes to create the
exception store API.  I've created a number of tests and run our QA
department's tests on this group and it holds up just fine.  I consider
this group ready for immediate review/inclusion.

The second bundle can be found at
http://patchwork.kernel.org/bundle/jbrassow/Exception%20Store%20API%
20group2/  This is the second stage of changes to create the exception
store API.  This group is currently in testing/refinement.  I expect
that all of the patches in this group will be "superseded" by a new set
which I will post in the next week or so.  (The above link will always
contain the most up-to-date patches.)  Comments and input on this set
are very welcome at this stage.

Also for reference, I've created a bundle for the cluster-aware mirror
log module.  It can be found at
http://patchwork.kernel.org/bundle/jbrassow/cluster%20dirty%20log/

I hope this helps clear things up and speed things along.

 brassow
