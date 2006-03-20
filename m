From: Andrew Morton <akpm@osdl.org>
Subject: Re: dm: bio split bvec fix
Date: Mon, 20 Mar 2006 14:05:34 -0800
Message-ID: <20060320140534.1feeccca.akpm@osdl.org>
References: <20060320192155.GU4724@agk.surrey.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20060320192155.GU4724@agk.surrey.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alasdair G Kergon <agk@redhat.com>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

Alasdair G Kergon <agk@redhat.com> wrote:
>
> The code that handles bios that span table target boundaries by breaking
>  them up into smaller bios will not split an individual struct bio_vec
>  into more than two pieces.  Sometimes more than that are required.
> 
>  This patch adds a loop to break the second piece up into as many
>  pieces as are necessary.

Should this go into 2.6.16.1?
