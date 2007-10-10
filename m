From: Eddie Williams <Eddie.Williams@steeleye.com>
Subject: should the tur libchecker handle unit attention
	conditions?
Date: Wed, 10 Oct 2007 11:48:59 -0400
Message-ID: <1192031339.4086.37.camel@gator.sc.steeleye.com>
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
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids


I have noticed situations where paths bounce using the tur libchecker
due to unit attention conditions.  Would there be any objection for
attempting an automatic single retry in tur.c for a UA condition?

Eddie Williams
