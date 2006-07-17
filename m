From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: md and dm
Date: Mon, 17 Jul 2006 05:36:37 +0100
Message-ID: <20060717043637.GB14011@agk.surrey.redhat.com>
References: <539C0A297AA0C74581CB5AF82D53729101CC7DDD@HSDLNTD1110010.noida.hcltech.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <539C0A297AA0C74581CB5AF82D53729101CC7DDD@HSDLNTD1110010.noida.hcltech.com>
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

On Wed, Jul 05, 2006 at 01:19:12PM +0530, Rajat Sharma, Noida wrote:
> Does device-mapper uses md driver anyhow??
 
They are completely independent implementations - use one or the other.
The md implementation provides only basic functionality.

Alasdair
-- 
agk@redhat.com
