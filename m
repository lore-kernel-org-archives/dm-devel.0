From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH] dm snapshot: add allocated metadata to
	snapshot status
Date: Fri, 9 Oct 2009 12:45:09 +0100
Message-ID: <20091009114509.GA3054@agk-dp.fab.redhat.com>
References: <1255017269-4429-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1255017269-4429-1-git-send-email-snitzer@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

I'm thinking a formula more like:
  ((current_area - 2) / (exceptions_per_area + 1) + 3
for the number of metadata chunks.
(Untested.)

Try it - then write to the origin one chunk at a time and check the output.
(Add 'current_area' to the status line while you are testing it.)

Alasdair
