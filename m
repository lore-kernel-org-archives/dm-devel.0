From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: Re: [PATCH 1/2] multipath-tools: move COPYING to
 COPYING.LESSER
Date: Wed, 28 Mar 2018 21:40:19 +0200
Message-ID: <597ef512-842d-633f-b6f9-d2156b4aa931@gmail.com>
References: <20180327182819.20163-1-xose.vazquez@gmail.com>
	<1522188190.13140.53.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1522188190.13140.53.camel@suse.com>
Content-Language: en-GB
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Martin Wilck <mwilck@suse.com>, Christophe Varoqui <christophe.varoqui@opensvc.com>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 03/28/2018 12:03 AM, Martin Wilck wrote:

> On Tue, 2018-03-27 at 20:28 +0200, Xose Vazquez Perez wrote:
>> As recommended by FSF: https://www.gnu.org/licenses/gpl-howto.html
>>
>> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
>> Cc: device-mapper development <dm-devel@redhat.com>
>> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
>> ---
>>  COPYING => COPYING.LESSER | 0
>>  1 file changed, 0 insertions(+), 0 deletions(-)
>>  rename COPYING => COPYING.LESSER (100%)
>>
>> diff --git a/COPYING b/COPYING.LESSER
>> similarity index 100%
>> rename from COPYING
>> rename to COPYING.LESSER
> 
> IMO you should only call it "COPYING.LESSER" if it's really the lesser
> GPL (aka LGPLv2.1).

LESSER is just the family of the licence, a tag.

COPYING.LIBRARY is really a very bad name. But if Christophe see
an objection to the "COPYING.LESSER" name, it could be rename to COPYING.LGPL
