From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm linear: disable WRITE SAME if it fails
Date: Wed, 5 Mar 2014 09:23:04 -0500
Message-ID: <20140305142303.GA2226@redhat.com>
References: <53042F91.4050201@huawei.com>
 <5316D295.8030205@huawei.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <5316D295.8030205@huawei.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: alex chen <alex.chen@huawei.com>
Cc: dm-devel@redhat.com, joseph.qi@huawei.com, agk@redhat.com
List-Id: dm-devel.ids

On Wed, Mar 05 2014 at  2:30am -0500,
alex chen <alex.chen@huawei.com> wrote:

> Who can help me review my patch? ths.

I can review it next week.  You raise a relevant issue.  But I don't
want to see each target having to implement this WRITE_SAME disable.

Anyway, This is 3.15 material.  I'm dealing with more urgent issues for
3.14 at the moment.

Mike
