From: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>
Subject: Re: [PATCH] libmultipath: fix discovery of devices with
 sysfs attr containing only spaces
Date: Sat, 11 Apr 2015 12:33:05 -0300
Message-ID: <55293EB1.8050302@linux.vnet.ibm.com>
References: <1428765500-11719-1-git-send-email-mauricfo@linux.vnet.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1428765500-11719-1-git-send-email-mauricfo@linux.vnet.ibm.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

On 04/11/2015 12:18 PM, Mauricio Faria de Oliveira wrote:
> Changing the comparison operator '<=' to '<' allows discovery to continue.

This is changed only for rev; vendor & model seem unlikely to hit this.
I can submit a more general patch for the 3 attributes, if required.

-- 
Mauricio Faria de Oliveira
IBM Linux Technology Center
