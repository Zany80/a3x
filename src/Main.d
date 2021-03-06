procedure Main (* -- *)
	"verbose?" NVRAMGetVar dup if (0 ==)
		drop "false" "verbose?" NVRAMSetVar
		"false"
	end

	if ("true" strcmp)
		ConsoleUserOut
	end else
		BootUI
	end

	"auto-boot?" NVRAMGetVar dup if (0 ==)
		drop "true" "auto-boot?" NVRAMSetVar
		"true"
	end

	if ("true" strcmp)
		auto r
		AutoBoot r!
		if (r@ 1 ~=)
			if (r@ 9 ==)
				(* system software error: make sure not to clear any message
				previously drawn on the framebuffer *)

				auto gcn
				"/gconsole" DevTreeWalk gcn!

				if (gcn@ 0 ~=)
					gcn@ DeviceSelectNode
						"suppressDraw" DCallMethod drop
					DeviceExit
				end
			end

			ConsoleUserOut
		end
		[r@]BootErrors@ " boot: %s\n" Printf
	end

	Monitor

	LateReset
end