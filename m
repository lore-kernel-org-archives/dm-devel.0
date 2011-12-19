From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [RFC][PATCH 0/3] persistent management feature for
 multipath-tools
Date: Mon, 19 Dec 2011 14:38:28 -0500
Message-ID: <20111219193827.GB17387@redhat.com>
References: <EE2129A8E578DC4E94D643D6C1C1C67D078966CE@BTCMVEXC2-PRD.hq.netapp.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <EE2129A8E578DC4E94D643D6C1C1C67D078966CE@BTCMVEXC2-PRD.hq.netapp.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Chauhan, Vijay" <Vijay.Chauhan@netapp.com>
Cc: device-mapper development <dm-devel@redhat.com>, "Stankey,
	Robert" <Robert.Stankey@netapp.com>, "Moger,
	Babu" <Babu.Moger@netapp.com>, christophe.varoqui@free.fr, "Dachepalli, Sudhir" <Sudhir.Dachepalli@netapp.com>
List-Id: dm-devel.ids

Why don't your patches have distinct subjects?

Also wrapping the 0th patch summary and patch headers of your messages
to ~80-100 characters would be helpful.

And providing stats in your patches would be ideal (allows high-level
view of which files are touched by a patch), e.g. 'git format-patch' or
'git diff -p --stat'.

Anyway, thanks for working on this.

Mike
