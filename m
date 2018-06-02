From: Mike Christie <mchristi@redhat.com>
Subject: Re: [PATCH 2/2] libmultipath: remove rbd code
Date: Fri, 1 Jun 2018 22:57:40 -0500
Message-ID: <5B1215B4.8020204@redhat.com>
References: <1527891722-11132-1-git-send-email-bmarzins@redhat.com>
	<1527891722-11132-2-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1527891722-11132-2-git-send-email-bmarzins@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>, device-mapper development <dm-devel@redhat.com>
Cc: Jason Dillaman <dillaman@redhat.com>
List-Id: dm-devel.ids

On 06/01/2018 05:22 PM, Benjamin Marzinski wrote:
> The Ceph tean has asked to drop support for multipathed rbd, since it
> was running into data corruption issues. There was never an upstream
> Ceph release based on it, and because of the corruption, there should be
> no users of this code. This patch simply reverts all the rbd code from
> multipath.
> 
> Cc: Michael Christie <mchristi@redhat.com>
> Cc: Jason Dillaman <dillaman@redhat.com>
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Reviewed-by: Mike Christie <mchristi@redhat.com>
