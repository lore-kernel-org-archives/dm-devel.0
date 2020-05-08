From: Wols Lists <antlists@youngman.org.uk>
Subject: Setting up dm-integrity for raid
Date: Fri, 8 May 2020 22:07:15 +0100
Message-ID: <5EB5CA03.9000006@youngman.org.uk>
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

It's a bit quiet in here, isn't it? :-)

I'm building a system (which I plan to document for the linux raid
wiki), and I'm wondering what to do. Unfortunately, "man
integritysetup", like so much documentation, is clear as mud to a newbie.

I've currently got /dev/sdb3 formatting away. Will this make a device
appear in /dev? Do I need to do an "integritysetup open" to create the
device so I can pass it to "mdadm --create"? Will that device survive a
reboot, or do I need to put the open command in my startup so that mdadm
can find it?

I guess I will need to sort out adding stuff to mdadm, so that it can
sort it all out for itself, but at the moment it's a case of "as soon as
someone explains it to me, the documentation will become crystal clear" :-)

Cheers,
Wol
