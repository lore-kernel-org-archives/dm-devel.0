From: Tim Gardner <tim.gardner@canonical.com>
Subject: Re: [PATCH linux-next v2] DM RAID:
 validate_raid_redundancy: Silence uninitialized variable warning
Date: Thu, 13 Jun 2013 10:00:13 -0600
Message-ID: <51B9EC8D.7040702@canonical.com>
References: <20130221131931.GA29577@agk-dp.fab.redhat.com>
	<1361458226-8142-1-git-send-email-tim.gardner@canonical.com>
	<CA+ydwtq_THgL87ESb4Z4T8pMhZUQiAX_9qac2agPwHABGEjuRA@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CA+ydwtq_THgL87ESb4Z4T8pMhZUQiAX_9qac2agPwHABGEjuRA@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Tommi Rantala <tt.rantala@gmail.com>
Cc: linux-raid@vger.kernel.org, dm-devel@redhat.com, LKML <linux-kernel@vger.kernel.org>, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On 06/13/2013 09:30 AM, Tommi Rantala wrote:
> 2013/2/21 Tim Gardner <tim.gardner@canonical.com>:
>> drivers/md/dm-raid.c:453:53: warning: 'rebuilds_per_group' may be used uninitialized in this function [-Wuninitialized]
>> drivers/md/dm-raid.c:383:11: note: 'rebuilds_per_group' was declared here
> 
> Hello, is this patch getting merged? I'm also seeing this exact same
> compiler warning in my mainline builds.
> 
> Tommi
> 

Dunno. I haven't hassled anyone because it _is_ just a warning.
-- 
Tim Gardner tim.gardner@canonical.com
