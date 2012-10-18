From: Joe Thornber <thornber@redhat.com>
Subject: Re: [PATCH] dm-persistent-data: rename node to btree_node
Date: Thu, 18 Oct 2012 10:44:10 +0100
Message-ID: <20121018094408.GA5564@ubuntu>
References: <Pine.LNX.4.64.1210172233240.6304@file.rdu.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1210172233240.6304@file.rdu.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Wed, Oct 17, 2012 at 10:48:00PM -0400, Mikulas Patocka wrote:
> dm-persistent-data: rename node to btree_node
> 
> This patch fixes compilation failure on sparc32
> 
> struct node is already defined in include/linux/node.h. On sparc32, it
> happens to be included through other dependencies and persistent-data
> doesn't compile because of conflicting declarations.
> 
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

Thanks Mikulas,

I've merged into the thin-dev branch of my github tree.

Alasdair could you push this upstream please.

- Joe
