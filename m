From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: "queue if no paths" infinite recursion when there are
	no paths
Date: Thu, 24 Feb 2005 02:46:11 +0000
Message-ID: <20050224024611.GW14093@agk.surrey.redhat.com>
References: <C2EEB4E538D3DC48BF57F391F422779321A7CE@SRMANNING.eng.emc.com>
	<20050224023732.GV14093@agk.surrey.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20050224023732.GV14093@agk.surrey.redhat.com>
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

On Thu, Feb 24, 2005 at 02:37:32AM +0000, Alasdair G Kergon wrote:
> if (!m->queue_if_no_path &&!m->suspended) {

Invert that of course. It's late:-(

if (!m->queue_if_no_path || m->suspended) {
 
Alasdair
