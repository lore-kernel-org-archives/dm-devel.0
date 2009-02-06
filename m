From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Subject: Re: [PATCH] dm-path-selector: fix refcount corruption
Date: Fri, 06 Feb 2009 10:04:08 +0900
Message-ID: <498B8C88.4010201@ce.jp.nec.com>
References: <498AE0B5.5050709@ce.jp.nec.com>
	<D61CE787-206C-439C-AAB1-4EEFE5C7FF51@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <D61CE787-206C-439C-AAB1-4EEFE5C7FF51@redhat.com>
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

Hi Jonathan,

Jonathan Brassow wrote:
> On Feb 5, 2009, at 6:51 AM, Jun'ichi Nomura wrote:
> 
>> @@ -136,11 +126,6 @@ int dm_unregister_path_selector(struct p
>>         return -EINVAL;
>>     }
>>
>> -    if (psi->use) {
>> -        up_write(&_ps_lock);
>> -        return -ETXTBSY;
>> -    }
>> -
>>     list_del(&psi->list);
> 
> 
> We still need this in some form, don't we?  Like 'if (module_refcount...'?

I don't think so.
dm_unregister_path_selector() is called from module_exit function. So it is called when the refcount is 0.

Thanks,
-- 
Jun'ichi Nomura, NEC Corporation
