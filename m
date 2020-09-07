From: lixiaokeng <lixiaokeng@huawei.com>
Subject: Re: [PATCH 11/14] mpathpersist: check whether malloc
 paramp->trnptid_list, fails in handle_args func
Date: Mon, 7 Sep 2020 20:26:56 +0800
Message-ID: <b26b27f9-3c6e-8b9c-baa1-c72fd0cf7d96@huawei.com>
References: <37544d4c-950f-4281-3b66-e4d1884c5167@huawei.com>
	<eeea4f08-bcb1-65b6-2fe8-b078961a07d3@huawei.com>
	<20200904235252.GG11108@octiron.msp.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200904235252.GG11108@octiron.msp.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Content-Language: en-GB
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: linfeilong <linfeilong@huawei.com>, dm-devel mailing list <dm-devel@redhat.com>, Martin Wilck <mwilck@suse.com>, "liuzhiqiang (I)" <liuzhiqiang26@huawei.com>
List-Id: dm-devel.ids


>>
>> -		paramp= malloc(sizeof(struct prout_param_descriptor) + (sizeof(struct transportid *)*(MPATH_MX_TIDS )));
>> -
>> -		memset(paramp, 0, sizeof(struct prout_param_descriptor) + (sizeof(struct transportid *)*(MPATH_MX_TIDS)));
> 
> When looking at your patch, I noticed that this function has both
> num_transport and num_transportids, but only num_transport is used,
> while num_transportids is reported back to the user.  I realize that
> this is only tangentially related to your patch, but if you could
> combine these two varaiables, that would be helpful.
> 

Hi Ben:
  Thanks for you great advice. I will make patch v2 following your
advice.

-Lixiaokeng
