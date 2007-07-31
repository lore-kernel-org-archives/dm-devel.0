From: Dave Wysochanski <dwysocha@redhat.com>
Subject: [RFC] Naming of dm-multipath hardware handler modules
Date: Tue, 31 Jul 2007 16:16:52 -0400
Message-ID: <1185913012.4392.46.camel@linux-cxyg>
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
To: dm-devel <dm-devel@redhat.com>
List-Id: dm-devel.ids

Do we have an agreed upon scheme?

I noticed in 2.6.23-rc1, the RDAC module is named "dm-mpath-rdac.ko",
but the source file is "dm-rdac.c".  Should we be naming things
"dm-mpath-hwhname" everywhere?  If so, should we rename dm-emc?

I was not sure exactly what was correct for the HP handler.  Currently
it follows the dm-emc scheme, which is probably wrong.
