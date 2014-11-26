From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm-bufio: fix memleak when using a dm_buffer's
	inline bio
Date: Wed, 26 Nov 2014 10:09:08 -0500
Message-ID: <20141126150908.GB30136@redhat.com>
References: <20141126014515.GE10050@birch.djwong.org>
	<20141126034103.GA26585@redhat.com>
	<20141126040008.GF10050@birch.djwong.org>
	<20141126142832.GB29855@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20141126142832.GB29855@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: device-mapper development <dm-devel@redhat.com>, linux-kernel@vger.kernel.org, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Wed, Nov 26 2014 at  9:28am -0500,
Mike Snitzer <snitzer@redhat.com> wrote:

> 
> But in the context of bufio's embedded bio, using .bi_private seems
> fine.  Just needs a comment.  I'll fixup and get your patch staged (and
> will CC stable).

Staged for 3.19, see:
https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-for-3.19&id=c370192f925cf34280c7f6257e86dd79f79529d6
